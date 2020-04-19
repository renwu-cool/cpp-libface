#include <napi.h>
#include <string>
using namespace std;
Napi::Value Add(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();

  // if (info.Length() < 2) {
  //   Napi::TypeError::New(env, "Wrong number of arguments")
  //       .ThrowAsJavaScriptException();
  //   return env.Null();
  // }

  if (!info[0].IsNumber() || !info[1].IsNumber()) {
    Napi::TypeError::New(env, "Wrong arguments").ThrowAsJavaScriptException();
    return env.Null();
  }

  // double arg0 = info[0].As<Napi::Number>().DoubleValue();
  // double arg1 = info[1].As<Napi::Number>().DoubleValue();
  string keyword = info[0].ToString().Utf8Value();
  Napi::String result = Napi::String::New(env, keyword+"!");

  return result;
}

Napi::Object Init(Napi::Env env, Napi::Object exports) {
  exports.Set(Napi::String::New(env, "add"), Napi::Function::New(env, Add));
  return exports;
}

NODE_API_MODULE(addon, Init)
