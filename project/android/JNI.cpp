#include <ExternalInterface.h>
#include <Utils.h>
#include <jni.h>
#include <pthread.h>
#include <ByteArray.h>
#include <map>

#include <android/log.h>

using namespace nme;

extern JNIEnv *GetEnv();

enum JNIElement
{
   jniUnknown,
   jniObjectString,
   jniObjectHaxe,
   jniObject,
   jniPODStart,
   jniBoolean = jniPODStart,
   jniByte,
   jniChar,
   jniShort,
   jniInt,
   jniLong,
   jniFloat,
   jniDouble,
   jniVoid,
   jniELEMENTS,
};


static bool sInit = false;
jclass GameActivity;
jclass ObjectClass;
jmethodID postUICallback;
jclass HaxeObject;
jmethodID HaxeObject_create;
jfieldID __haxeHandle;


void CheckException(JNIEnv *env, bool inThrow=true)
{
   jthrowable exc = env->ExceptionOccurred();
   if (exc)
   {
      env->ExceptionDescribe();
      env->ExceptionClear();
      if (inThrow)
        val_throw(alloc_string("JNI Exception"));
   }
}


struct JNIType
{
   typedef std::map<JNIType,jclass> ClassMap;

   JNIType() : element(jniUnknown), arrayDepth(0) { }
   JNIType(JNIElement inElem, int inDepth) :
      element(inElem), arrayDepth(inDepth) { }
   JNIType elemType() { return (arrayDepth>0) ? JNIType(element,arrayDepth-1) : JNIType(); }

   bool isUnknownType() const { return element==jniUnknown && arrayDepth==0; }
   bool isUnknown() const { return element==jniUnknown; }
   bool isObject() const { return element<jniPODStart || arrayDepth>0; }
   bool operator<(const JNIType &inRHS) const
   {
      if (arrayDepth!=inRHS.arrayDepth)
         return arrayDepth<inRHS.arrayDepth;
      return element < inRHS.element;
   }

   jclass getClass(JNIEnv *inEnv)
   {
      if (!isObject())
      {
         return 0;
      }

      if (arrayDepth>1 || (arrayDepth==1 && element<jniPODStart))
         return ObjectClass;

      ClassMap::iterator i = mClasses.find(*this);
      if (i!=mClasses.end())
         return i->second;

      std::string name(arrayDepth?"[":"");
      switch(element)
      {
         case jniObjectString: name += "java/lang/String"; break;
         case jniObjectHaxe: name += "org/haxe/nme/HaxeObject"; break;

         case jniUnknown:
         case jniObject: name += "java/lang/Object"; break;

         case jniBoolean: name += "Z"; break;
         case jniVoid: name += "V"; break;
         case jniByte: name += "B"; break;
         case jniChar: name += "C"; break;
         case jniShort: name += "S"; break;
         case jniInt: name += "I"; break;
         case jniLong: name += "J"; break;
         case jniFloat: name += "F"; break;
         case jniDouble: name += "D"; break;
         default:
            mClasses[*this] = 0;
            return 0;
      }

      jclass result  = inEnv->FindClass(name.c_str());
      if (result)
         inEnv->NewGlobalRef(result);
      mClasses[*this] = result;
      return result;
   }

   static void init(JNIEnv *inEnv)
   {
      for(int i=0;i<jniELEMENTS;i++)
         elementGetValue[i] = 0;

      elementClass[jniBoolean] = inEnv->FindClass("java/lang/Boolean");
      elementGetValue[jniBoolean] = inEnv->GetMethodID(elementClass[jniBoolean],"booleanValue","()Z");
      CheckException(inEnv,false);
      elementClass[jniByte] = inEnv->FindClass("java/lang/Byte");
      elementGetValue[jniByte] = inEnv->GetMethodID(elementClass[jniByte],"doubleValue","()D");
      CheckException(inEnv,false);
      elementClass[jniChar] = inEnv->FindClass("java/lang/Character");
      elementGetValue[jniChar] = inEnv->GetMethodID(elementClass[jniChar],"charValue","()C");
      CheckException(inEnv,false);
      elementClass[jniShort] = inEnv->FindClass("java/lang/Short");
      elementGetValue[jniShort] = inEnv->GetMethodID(elementClass[jniShort],"doubleValue","()D");
      CheckException(inEnv,false);
      elementClass[jniInt] = inEnv->FindClass("java/lang/Integer");
      elementGetValue[jniInt] = inEnv->GetMethodID(elementClass[jniInt],"doubleValue","()D");
      CheckException(inEnv,false);
      elementClass[jniLong] = inEnv->FindClass("java/lang/Long");
      elementGetValue[jniLong] = inEnv->GetMethodID(elementClass[jniLong],"doubleValue","()D");
      CheckException(inEnv,false);
      elementClass[jniFloat] = inEnv->FindClass("java/lang/Float");
      elementGetValue[jniFloat] = inEnv->GetMethodID(elementClass[jniFloat],"doubleValue","()D");
      CheckException(inEnv,false);
      elementClass[jniDouble] = inEnv->FindClass("java/lang/Double");
      elementGetValue[jniDouble] = inEnv->GetMethodID(elementClass[jniDouble],"doubleValue","()D");
      CheckException(inEnv,false);
      elementClass[jniVoid] = 0;

      for(int i=0;i<jniELEMENTS;i++)
      {
         JNIType type((JNIElement)i,1);
         if (i==jniVoid)
            elementArrayClass[i] = 0;
         else
            elementArrayClass[i] = type.getClass(inEnv);
         if (i<jniPODStart)
            elementClass[i] = JNIType((JNIElement)i,0).getClass(inEnv);
         else
         {
            //ELOG("POD type %d = %p", i, elementClass[i]);
         }
         CheckException(inEnv,false);
      }
   }


   JNIElement element;
   static jclass elementClass[jniELEMENTS];
   static jclass elementArrayClass[jniELEMENTS];
   static jmethodID elementGetValue[jniELEMENTS];
   int        arrayDepth;
   static     ClassMap mClasses;
};

JNIType::ClassMap JNIType::mClasses;
//JNIType JNIType::elementClass[jniELEMENTS];
jclass JNIType::elementClass[jniELEMENTS];
jmethodID JNIType::elementGetValue[jniELEMENTS];
jclass JNIType::elementArrayClass[jniELEMENTS];

AutoGCRoot *gCallback = 0;

void JNIInit(JNIEnv *env)
{
   if (sInit)
      return;
   GameActivity = env->FindClass("org/haxe/nme/GameActivity");
   postUICallback = env->GetStaticMethodID(GameActivity, "postUICallback", "(J)V");

   ObjectClass = env->FindClass("java/lang/Object");

   HaxeObject   = JNIType(jniObjectHaxe,0).getClass(env);
   HaxeObject_create = env->GetStaticMethodID(HaxeObject, "create", "(J)Lorg/haxe/nme/HaxeObject;");
   __haxeHandle = env->GetFieldID(HaxeObject, "__haxeHandle", "J");

   JNIType::init(env);

   sInit = true;
}

value nme_jni_init_callback(value inCallback)
{
   if (!gCallback)
      gCallback = new AutoGCRoot(inCallback);
   return alloc_null();
}
DEFINE_PRIM(nme_jni_init_callback,1);


struct JavaHaxeReference
{
   JavaHaxeReference(value inValue) : root(inValue)
   {
      refCount = 1;
   }

   int        refCount;
   AutoGCRoot root;
};

typedef std::map<value,JavaHaxeReference *> JavaHaxeReferenceMap;
JavaHaxeReferenceMap gJavaObjects;
bool gJavaObjectsMutexInit = false;
pthread_mutex_t gJavaObjectsMutex;

jobject CreateJavaHaxeObjectRef(JNIEnv *env,  value inValue)
{
   JNIInit(env);
   if (!gJavaObjectsMutexInit)
   {
      gJavaObjectsMutexInit = false;
      pthread_mutex_init(&gJavaObjectsMutex,0);
   }

   pthread_mutex_lock(&gJavaObjectsMutex);
   JavaHaxeReferenceMap::iterator it = gJavaObjects.find(inValue);
   if (it!=gJavaObjects.end())
      it->second->refCount++;
   else
      gJavaObjects[inValue] = new JavaHaxeReference(inValue);
   pthread_mutex_unlock(&gJavaObjectsMutex);

   jobject result = env->CallStaticObjectMethod(HaxeObject, HaxeObject_create, (jlong)inValue);
   jthrowable exc = env->ExceptionOccurred();
   CheckException(env);
   return result;
}

void RemoveJavaHaxeObjectRef(value inValue)
{
   pthread_mutex_lock(&gJavaObjectsMutex);
   JavaHaxeReferenceMap::iterator it = gJavaObjects.find(inValue);
   if (it!=gJavaObjects.end())
   {
      it->second->refCount--;
      if (!it->second->refCount)
      {
         delete it->second;
         gJavaObjects.erase(it);
      }
   }
   else
   {
      ELOG("Bad jni reference count");
   }
   pthread_mutex_unlock(&gJavaObjectsMutex);
}


struct JNIObject : public nme::Object
{
   JNIObject(jobject inObject)
   {
      mObject = inObject;
      if (mObject)
         GetEnv()->NewGlobalRef(mObject);
   }
   ~JNIObject()
   {
      if (mObject)
         GetEnv()->DeleteGlobalRef(mObject);
   }
   operator jobject() { return mObject; }
   jobject GetJObject() { return mObject; }
   jobject mObject;
};



bool AbstractToJObject(value inValue, jobject &outObject)
{
   JNIObject *jniobj = 0;
   if (AbstractToObject(inValue,jniobj))
   {
      outObject = jniobj->GetJObject();
      return true;
   }

   static int id__jobject = -1;
   if (id__jobject<0)
      id__jobject =  val_id("__jobject");

   value jobj = val_field(inValue,id__jobject);
   if (val_is_null(jobj))
      return false;

   return AbstractToJObject(jobj,outObject);
}



value JStringToHaxe(JNIEnv *inEnv,jobject inObject)
{
   jboolean is_copy;
   const char *str = inEnv->GetStringUTFChars( (jstring)inObject, &is_copy);
   value result = alloc_string(str);
   inEnv->ReleaseStringUTFChars((jstring)inObject, str);
   return result;
}

value JObjectToHaxeObject(JNIEnv *env,jobject inObject)
{
   if (inObject)
   {
      jlong val = env->GetLongField(inObject,__haxeHandle);
      return (value)val;
   }

   return alloc_null();
}

/*
 *
 *
 */
#define ARRAY_SET(PRIM,JTYPE,CREATE) \
   case jni##PRIM: \
   { \
      if (len>0) \
      { \
          jboolean copy; \
          JTYPE *data = inEnv->Get##PRIM##ArrayElements((JTYPE##Array)inObject,&copy); \
          for(int i=0;i<len;i++) \
          { \
              val_array_set_i(result,i,CREATE(data[i])); \
          } \
          inEnv->Release##PRIM##ArrayElements((JTYPE##Array)inObject,data,JNI_ABORT); \
      } \
   }\
   break;

value JObjectToHaxe(JNIEnv *inEnv,JNIType inType,jobject inObject)
{
   if (inObject==0)
      return alloc_null();

   if (inType.isUnknownType())
   {
      jclass cls = inEnv->GetObjectClass(inObject);
      if (cls)
      {
         for(int i=0;i<jniELEMENTS;i++)
            if (JNIType::elementClass[i]==cls)
            {
               inType = JNIType((JNIElement)i,0);
               break;
            }
      
         if (inType.isUnknownType())
         {
            for(int i=0;i<jniELEMENTS;i++)
            {
               if (cls==JNIType::elementArrayClass[i])
               {
                 inType = JNIType((JNIElement)i,1);
                  break;
               }
            }
         }
      }

      if (inType.isUnknownType())
         inType = JNIType(jniObject,0);
   }

   if (inType.arrayDepth>1 || (inType.arrayDepth==1 && inType.element<jniPODStart) )
   {
      int len = inEnv->GetArrayLength((jarray)inObject);
      value result = alloc_array(len);
      JNIType child = inType.elemType();
      for(int i=0;i<len;i++)
      {
         val_array_set_i(result,i,JObjectToHaxe(inEnv,child,
                         inEnv->GetObjectArrayElement((jobjectArray)inObject,i) ) );
      }
      return result;
   }
   else if (inType.arrayDepth==1)
   {
      int len = inEnv->GetArrayLength((jarray)inObject);
      value result = alloc_array(len);
      switch(inType.element)
      {
         ARRAY_SET(Boolean,jboolean,alloc_bool)
         //ARRAY_SET(Byte,jbyte,alloc_int)
         ARRAY_SET(Char,jchar,alloc_int)
         ARRAY_SET(Short,jshort,alloc_int)
         ARRAY_SET(Int,jint,alloc_int)
         ARRAY_SET(Long,jlong,alloc_int)
         ARRAY_SET(Float,jfloat,alloc_float)
         ARRAY_SET(Double,jdouble,alloc_float)
         case jniByte:
            {
               if (len>0) {
                   jboolean copy;
                   jbyte *data = inEnv->GetByteArrayElements((jbyteArray)inObject,&copy);
                   for(int i=0;i<len;i++) {
                       val_array_set_i(result,i,alloc_int(data[i]));
                   }
                   inEnv->ReleaseByteArrayElements((jbyteArray)inObject,data,JNI_ABORT);
               }
            }
      }
      return result;
   }
   else switch(inType.element)
   {
      case jniObject:
         {
         JNIObject *obj = new JNIObject(inObject);
         return ObjectToAbstract(obj);
         }
      case jniObjectHaxe:
         return JObjectToHaxeObject(inEnv,inObject);
      case jniObjectString:
         return JStringToHaxe(inEnv,inObject);
      case jniVoid: return alloc_null();

      case jniBoolean:
          return alloc_bool(inEnv->CallBooleanMethod(inObject, JNIType::elementGetValue[jniBoolean]));

      case jniChar:
          return alloc_int(inEnv->CallCharMethod(inObject, JNIType::elementGetValue[jniChar]));

      case jniShort:
      case jniByte:
      case jniInt:
      case jniLong:
      case jniFloat:
      case jniDouble:
          return alloc_float(inEnv->CallDoubleMethod(inObject, JNIType::elementGetValue[inType.element] ) );


      default:
      {
         jclass cls = inEnv->GetObjectClass(inObject);
         if (cls)
         {
           jmethodID mid = inEnv->GetMethodID(cls,"toString","()V");
           if (mid)
              return JStringToHaxe(inEnv, inEnv->CallObjectMethod(cls,mid) );
         }
      }
   }

   return alloc_null();
}



const char *JNIParseType(const char *inStr, JNIType &outType,int inDepth=0)
{
   switch(*inStr++)
   {
      case 'B': outType=JNIType(jniByte,inDepth); return inStr;
      case 'C': outType=JNIType(jniChar,inDepth); return inStr;
      case 'D': outType=JNIType(jniDouble,inDepth); return inStr;
      case 'F': outType=JNIType(jniFloat,inDepth); return inStr;
      case 'I': outType=JNIType(jniInt,inDepth); return inStr;
      case 'J': outType=JNIType(jniLong,inDepth); return inStr;
      case 'S': outType=JNIType(jniShort,inDepth); return inStr;
      case 'V': outType=JNIType(jniVoid,inDepth); return inStr;
      case 'Z': outType=JNIType(jniBoolean,inDepth); return inStr;
      case '[':
         {
         return JNIParseType(inStr,outType,inDepth+1);
         }
      case 'L':
         {
            const char *src = inStr;
            while(*inStr!='\0' && *inStr!=';' && *inStr!=')')
               inStr++;
            if (*inStr!=';')
               break;
            if (!strncmp(src,"java/lang/String;",17) ||
                !strncmp(src,"java/lang/CharSequence;",23)  )
               outType = JNIType(jniObjectString,inDepth);
            else if (!strncmp(src,"org/haxe/nme/HaxeObject;",24))
               outType = JNIType(jniObjectHaxe,inDepth);
            else
               outType = JNIType(jniObject,inDepth);
            return inStr+1;
         }
   }
   outType = JNIType();
   return inStr;
}

#define ARRAY_COPY(PRIM,JTYPE) \
         case jni##PRIM: \
            { \
               JTYPE##Array arr = inEnv->New##PRIM##Array(len); \
               if (len>0) \
               { \
                  jboolean copy; \
                  JTYPE *data = inEnv->Get##PRIM##ArrayElements(arr,&copy); \
                  for(int i=0;i<len;i++) \
                  { \
                     data[i] = (JTYPE)val_number(val_array_i(inValue,i)); \
                  } \
                  inEnv->Release##PRIM##ArrayElements(arr,data,0); \
               } \
               out.l = arr; \
               return true; \
            }



bool HaxeToJNI(JNIEnv *inEnv, value inValue, JNIType inType, jvalue &out)
{
   if (inType.isUnknown())
      return false;
   else if (inType.arrayDepth>1 || (inType.arrayDepth==1 && inType.element<jniPODStart) )
   {
      int len = val_array_size(inValue);
      JNIType etype = inType.elemType();
      jclass cls = etype.getClass(inEnv);
      if (!cls)
         cls = JNIType(jniObject,inType.arrayDepth-1).getClass(inEnv);

      jobjectArray arr = (jobjectArray)inEnv->NewObjectArray(len,cls,0);
      for(int i=0;i<len;i++)
      {
         jvalue elem_i;
         HaxeToJNI(inEnv,val_array_i(inValue,i),etype,elem_i);
         inEnv->SetObjectArrayElement(arr,i,elem_i.l);
      }

      out.l = arr;
      return true;
   }
   else if (inType.arrayDepth==1)
   {
      int len = val_array_size(inValue);
      switch(inType.element)
      {
         ARRAY_COPY(Boolean,jboolean)
         //ARRAY_COPY(Byte,jbyte)
         ARRAY_COPY(Char,jchar)
         ARRAY_COPY(Short,jshort)
         ARRAY_COPY(Int,jint)
         ARRAY_COPY(Long,jlong)
         ARRAY_COPY(Float,jfloat)
         ARRAY_COPY(Double,jdouble)
         case jniByte:
            {
            jbyteArray arr = inEnv->NewByteArray(len);
            if (len>0) {
               jboolean copy;
               jbyte *data = inEnv->GetByteArrayElements(arr,&copy);
               for(int i=0;i<len;i++) {
                  data[i] = (int)val_number(val_array_i(inValue,i));
               }
               inEnv->ReleaseByteArrayElements(arr,data,0);
            }
            out.l = arr;
            return true;
            }
         case jniVoid: out.l = 0; return true;
      }
      return false;
   }
   else
   {
      switch(inType.element)
      {
         case jniObjectString:
            {
               out.l = inEnv->NewStringUTF(val_string(inValue));
               return true;
            }
         case jniObjectHaxe:
            out.l = CreateJavaHaxeObjectRef(inEnv,inValue);
            return true;
         case jniObject:
            {
               jobject obj = 0;
               if (!AbstractToJObject(inValue,obj))
               {
                  ELOG("HaxeToJNI : jniObject not an object %p", inValue);
                  return false;
               }
               out.l = obj;
               return true;
            }
         case jniBoolean: out.z = (bool)val_number(inValue); return true;
         case jniByte: out.b = (int)val_number(inValue); return true;
         case jniChar: out.c = (int)val_number(inValue); return true;
         case jniShort: out.s = (int)val_number(inValue); return true;
         case jniInt: out.i = (int)val_number(inValue); return true;
         case jniLong: out.j = (long)val_number(inValue); return true;
         case jniFloat: out.f = (float)val_number(inValue); return true;
         case jniDouble: out.d = val_number(inValue); return true;
         case jniVoid: out.l = 0; return true;
      }
   }

   return false;
}





struct JNIMethod : public nme::Object
{
   enum { MAX = 20 };

   JNIMethod(value inClass, value inMethod, value inSignature,bool inStatic)
   {
      JNIEnv *env = GetEnv();
      JNIInit(env);

      mClass = 0;
      mMethod = 0;
      mReturn = JNIType(jniVoid,0);
      mArgCount = 0;

      const char *method = val_string(inMethod);
      mIsConstructor = !strncmp(method,"<init>",6);


      mClass = env->FindClass(val_string(inClass));
      const char *signature = val_string(inSignature);
      if (mClass)
      {
         if (inStatic && !mIsConstructor)
            mMethod = env->GetStaticMethodID(mClass, method, signature);
         else
            mMethod = env->GetMethodID(mClass, method, signature);
      }
      if (Ok())
      {
         bool ok = ParseSignature(signature);
         if (!ok)
         {
            ELOG("Bad signature %s.", signature);
            mMethod = 0;
         }
      }
   }


   bool HaxeToJNIArgs(JNIEnv *inEnv, value inArray, jvalue *outValues)
   {
      if (val_array_size(inArray)!=mArgCount)
      {
         ELOG("Invalid array count: %d!=%d",val_array_size(inArray)!=mArgCount);
         return false;
      }
      for(int i=0;i<mArgCount;i++)
      {
         value arg_i = val_array_i(inArray,i);
         if (!HaxeToJNI(inEnv,arg_i,mArgType[i],outValues[i]))
         {
            ELOG("HaxeToJNI could not convert param %d (%p) to %dx%d",i, arg_i,
                 mArgType[i].element, mArgType[i].arrayDepth);
            return false;
         }
      }
      return true;
   }

   void CleanStringArgs()
   {
   }



   bool ParseSignature(const char *inSig)
   {
      if (*inSig++!='(')
          return false;

      mArgCount = 0;
      while(*inSig!=')')
      {
         if (mArgCount==MAX)
            return false;
         JNIType type;
         inSig = JNIParseType(inSig,type);
         if (type.isUnknown())
            return false;
         mArgType[mArgCount++] = type;
      }
      inSig++;
      JNIParseType(inSig,mReturn);
      return !mReturn.isUnknown();
   }

   bool Ok() const { return mMethod>0; }



   value CallStatic( value inArgs)
   {
      JNIEnv *env = GetEnv();
      jvalue jargs[MAX];
      if (!HaxeToJNIArgs(env,inArgs,jargs))
      {
         CleanStringArgs();
         ELOG("CallStatic - bad argument list");
         return alloc_null();
      }
      value result = 0;

      if (mIsConstructor)
      {
         jobject obj =  env->NewObjectA(mClass, mMethod, jargs);
         result =  JObjectToHaxe(env, JNIType(jniObject,0), obj);
      }
      else if (mReturn.isObject())
      {
         result = JObjectToHaxe(env,mReturn,env->CallStaticObjectMethodA(mClass, mMethod, jargs));
      }
      else switch(mReturn.element)
      {
         case jniVoid:
            result = alloc_null();
            env->CallStaticVoidMethodA(mClass, mMethod, jargs);
            break;
         case jniBoolean:
            result = alloc_bool(env->CallStaticBooleanMethodA(mClass, mMethod, jargs));
            break;
         case jniByte:
            result = alloc_int(env->CallStaticByteMethodA(mClass, mMethod, jargs));
            break;
         case jniChar:
            result = alloc_int(env->CallStaticCharMethodA(mClass, mMethod, jargs));
            break;
         case jniShort:
            result = alloc_int(env->CallStaticShortMethodA(mClass, mMethod, jargs));
            break;
         case jniInt:
            result = alloc_int(env->CallStaticIntMethodA(mClass, mMethod, jargs));
            break;
         case jniLong:
            result = alloc_int(env->CallStaticLongMethodA(mClass, mMethod, jargs));
            break;
         case jniFloat:
            result = alloc_float(env->CallStaticFloatMethodA(mClass, mMethod, jargs));
            break;
         case jniDouble:
            result = alloc_float(env->CallStaticDoubleMethodA(mClass, mMethod, jargs));
            break;
      }

      CleanStringArgs();
      CheckException(env);
      return result;
   }



   value CallMember(jobject inObject, value inArgs)
   {
      JNIEnv *env = GetEnv();

      jvalue jargs[MAX];
      if (!HaxeToJNIArgs(env,inArgs,jargs))
      {
         CleanStringArgs();
         ELOG("CallMember - bad argument list");
         return alloc_null();
      }
      value result = 0;

      if (mReturn.isObject())
      {
         result = JObjectToHaxe(env,mReturn,env->CallObjectMethodA(inObject, mMethod, jargs));
      }
      else switch(mReturn.element)
      {
         case jniVoid:
            result = alloc_null();
            env->CallVoidMethodA(inObject, mMethod, jargs);
            break;
         case jniBoolean:
            result = alloc_bool(env->CallBooleanMethodA(inObject, mMethod, jargs));
            break;
         case jniByte:
            result = alloc_int(env->CallByteMethodA(inObject, mMethod, jargs));
            break;
         case jniChar:
            result = alloc_int(env->CallCharMethodA(inObject, mMethod, jargs));
            break;
         case jniShort:
            result = alloc_int(env->CallShortMethodA(inObject, mMethod, jargs));
            break;
         case jniInt:
            result = alloc_int(env->CallIntMethodA(mClass, mMethod, jargs));
            break;
         case jniLong:
            result = alloc_int(env->CallLongMethodA(inObject, mMethod, jargs));
            break;
         case jniFloat:
            result = alloc_float(env->CallFloatMethodA(inObject, mMethod, jargs));
            break;
         case jniDouble:
            result = alloc_float(env->CallDoubleMethodA(inObject, mMethod, jargs));
            break;
      }

      CleanStringArgs();
      return result;
   }

   jclass    mClass;
   jmethodID mMethod;
   JNIType   mReturn;
   JNIType   mArgType[MAX];
   int       mArgCount;
   bool      mIsConstructor;
};


value nme_jni_create_method(value inClass, value inMethod, value inSig,value inStatic)
{
   JNIMethod *method = new JNIMethod(inClass,inMethod,inSig,val_bool(inStatic) );
   if (method->Ok())
      return ObjectToAbstract(method);
   ELOG("nme_jni_create_method - failed");
   delete method;
   return alloc_null();
}
DEFINE_PRIM(nme_jni_create_method,4);


value nme_jni_call_static(value inMethod, value inArgs)
{
   JNIMethod *method;
   if (!AbstractToObject(inMethod,method))
      return alloc_null();
   value result =  method->CallStatic(inArgs);
   return result;
}
DEFINE_PRIM(nme_jni_call_static,2);


value nme_jni_call_member(value inMethod, value inObject, value inArgs)
{
   JNIMethod *method;
   jobject object;
   if (!AbstractToObject(inMethod,method))
   {
      ELOG("nme_jni_call_member - not a method");
      return alloc_null();
   }
   if (!AbstractToJObject(inObject,object))
   {
      ELOG("nme_jni_call_member - invalid this");
      return alloc_null();
   }
   return method->CallMember(object,inArgs);
}
DEFINE_PRIM(nme_jni_call_member,3);




value nme_post_ui_callback(value inCallback)
{
   JNIEnv *env = GetEnv();
   JNIInit(env);

   AutoGCRoot *root = new AutoGCRoot(inCallback);
   ELOG("NME set onCallback %p",root);
   env->CallStaticVoidMethod(GameActivity, postUICallback, (jlong) root);
   jthrowable exc = env->ExceptionOccurred();
   if (exc)
   {
      env->ExceptionDescribe();
      env->ExceptionClear();
      delete root;
      val_throw(alloc_string("JNI Exception"));
   }

   return alloc_null();
}
DEFINE_PRIM(nme_post_ui_callback,1);


extern "C"
{

#ifdef __GNUC__
  #define JAVA_EXPORT __attribute__ ((visibility("default"))) JNIEXPORT
#else
  #define JAVA_EXPORT JNIEXPORT
#endif


JAVA_EXPORT void JNICALL Java_org_haxe_nme_NME_onCallback(JNIEnv * env, jobject obj, jlong handle)
{
   int top = 0;
   gc_set_top_of_stack(&top,true);

   ELOG("NME onCallback %p",(void *)handle);
   AutoGCRoot *root = (AutoGCRoot *)handle;
   val_call0( root->get() );
   delete root;
   gc_set_top_of_stack(0,true);
}


JAVA_EXPORT jobject JNICALL Java_org_haxe_nme_NME_releaseReference(JNIEnv * env, jobject obj, jlong handle)
{
   value val = (value)handle;
   RemoveJavaHaxeObjectRef(val);
   return 0;
}

value CallHaxe(JNIEnv * env, jobject obj, jlong handle, jstring function, jobject inArgs)
{
   ELOG("CallHaxe %p", gCallback);
   if (gCallback)
   {
      value objValue = (value)handle;
      value funcName = JStringToHaxe(env,function);
      value args = JObjectToHaxe(env,JNIType(jniUnknown,1),inArgs);
      ELOG("Using %d args", val_array_size(args) );
      return val_call3(gCallback->get(),objValue,funcName,args);
   }
   else
   {
      ELOG("NME CallHaxe - init not called.");
      return alloc_null();
   }
}



JAVA_EXPORT jobject JNICALL Java_org_haxe_nme_NME_callObjectFunction(JNIEnv * env, jobject obj, jlong handle, jstring function, jobject args)
{
   int top = 0;
   gc_set_top_of_stack(&top,true);

   value result = CallHaxe(env,obj,handle,function,args);

   // TODO:
   //jobject val = JAnonToHaxe(result);
   jobject val = 0;

   gc_set_top_of_stack(0,true);
   return val;
}


JAVA_EXPORT jdouble JNICALL Java_org_haxe_nme_NME_callNumericFunction(JNIEnv * env, jobject obj, jlong handle, jstring function, jobject args)
{
   int top = 0;
   gc_set_top_of_stack(&top,true);

   value result = CallHaxe(env,obj,handle,function,args);

   double val = val_number(result);

   gc_set_top_of_stack(0,true);
   return val;
}



}


