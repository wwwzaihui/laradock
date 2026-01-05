// 全局类型声明：window.lowcode 与 Geetest 初始化函数
declare global {
  interface Window {
    lowcode: any;
    initGeetest: (userConfig: any, callback: (captchaObj: any) => void) => void;
  }
  // 全局函数声明，允许直接调用 initGeetest(...)
  function initGeetest(userConfig: any, callback: (captchaObj: any) => void): void;
}

// 极验返回结果类型
declare type GeetestResult = {
  geetestChallenge: string;
  geetestValidate: string;
  geetestSeccode: string;
};

export {};