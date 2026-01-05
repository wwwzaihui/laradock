// Ambient declarations for Geetest used in SmsCodeInput
declare function initGeetest(
  userConfig: any,
  callback: (captchaObj: any) => void,
): void;

type GeetestResult = {
  geetestChallenge: string;
  geetestValidate: string;
  geetestSeccode: string;
};

declare global {
  interface Window {
    initGeetest?: typeof initGeetest;
  }
}

export {};