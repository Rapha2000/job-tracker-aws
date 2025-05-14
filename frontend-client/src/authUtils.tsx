export const getCurrentUserEmail = () => {
  const token = sessionStorage.getItem("idToken");
  if (!token) throw new Error("No ID token");
  const payload = JSON.parse(atob(token.split(".")[1]));
  console.log("payload: ", payload);
  return payload["cognito:username"]; 
};