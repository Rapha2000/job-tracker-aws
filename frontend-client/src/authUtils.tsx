export const getCurrentUserEmail =  (USE_MOCK: boolean) => {
  if (!USE_MOCK) {
    const token = sessionStorage.getItem("idToken");
    if (!token) throw new Error("No ID token");
    const payload = JSON.parse(atob(token.split(".")[1]));
    return payload["cognito:username"]; 
  } else {
    return "mockuser@gmail.com"
  }
};