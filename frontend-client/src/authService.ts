// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: Apache-2.0

import {
  CognitoIdentityProviderClient,
  InitiateAuthCommand,
  SignUpCommand,
  ConfirmSignUpCommand,
  type InitiateAuthCommandInput,
  type SignUpCommandInput,
  type ConfirmSignUpCommandInput,
} from "@aws-sdk/client-cognito-identity-provider";
// import config from "./config.json";

const aws_region = import.meta.env.VITE_REGION;

console.log("REGION: ", import.meta.env.VITE_REGION);
console.log("API URL: ", import.meta.env.VITE_API_URL);


export const cognitoClient = new CognitoIdentityProviderClient({
  region: aws_region,
});

export const signIn = async (username: string, password: string) => {

  const cognito_user_pool_client_id = import.meta.env.VITE_CLIENT_ID;

  const params: InitiateAuthCommandInput = {
    AuthFlow: "USER_PASSWORD_AUTH",
    ClientId: cognito_user_pool_client_id,
    AuthParameters: {
      USERNAME: username,
      PASSWORD: password,
    },
  };
  try {
    const command = new InitiateAuthCommand(params);
    const { AuthenticationResult } = await cognitoClient.send(command);
    if (AuthenticationResult) {
      sessionStorage.setItem("idToken", AuthenticationResult.IdToken || "");
      sessionStorage.setItem(
        "accessToken",
        AuthenticationResult.AccessToken || "",
      );
      sessionStorage.setItem(
        "refreshToken",
        AuthenticationResult.RefreshToken || "",
      );
      return AuthenticationResult;
    }
  } catch (error) {
    console.error("Error signing in: ", error);
    throw error;
  }
};

export const signUp = async (email: string, password: string) => {

  const cognito_user_pool_client_id = import.meta.env.VITE_CLIENT_ID;

  const params: SignUpCommandInput = {
    ClientId: cognito_user_pool_client_id,
    Username: email,
    Password: password,
    UserAttributes: [
      {
        Name: "email",
        Value: email,
      },
    ],
  };
  try {
    const command = new SignUpCommand(params);
    const response = await cognitoClient.send(command);
    console.log("Sign up success: ", response);
    return response;
  } catch (error) {
    console.error("Error signing up: ", error);
    throw error;
  }
};

export const confirmSignUp = async (username: string, code: string) => {

  const cognito_user_pool_client_id = import.meta.env.VITE_CLIENT_ID;

  const params: ConfirmSignUpCommandInput = {
    ClientId: cognito_user_pool_client_id,
    Username: username,
    ConfirmationCode: code,
  };
  try {
    const command = new ConfirmSignUpCommand(params);
    await cognitoClient.send(command);
    console.log("User confirmed successfully");
    return true;
  } catch (error) {
    console.error("Error confirming sign up: ", error);
    throw error;
  }
};