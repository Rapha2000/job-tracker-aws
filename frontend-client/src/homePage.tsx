// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: Apache-2.0

import { useNavigate } from "react-router-dom";
import React, { use, useEffect, useState } from "react";
import mockApplications from "./mockApplications";
import {
  fetchApplications,
  createApplication,
  deleteApplication,
  updateApplication,
} from "./apiService";
import { getCurrentUserEmail } from "./authUtils"; 

const USE_MOCK = true;

type Application = {
  user_id: string;
  job_id?: string;
  company: string;
  position: string;
  status: string;
  date_applied: string;
  notes: string;
  tags: string[];
};

function parseJwt(token) {
  const base64Url = token.split(".")[1];
  const base64 = base64Url.replace(/-/g, "+").replace(/_/g, "/");
  const jsonPayload = decodeURIComponent(
    window
      .atob(base64)
      .split("")
      .map((c) => `%${(`00${c.charCodeAt(0).toString(16)}`).slice(-2)}`)
      .join(""),
  );
  return JSON.parse(jsonPayload);
}

const HomePage = () => {
  const navigate = useNavigate();
  const idToken = parseJwt(sessionStorage.idToken.toString());
  const accessToken = parseJwt(sessionStorage.accessToken.toString());
  console.log(
    `Amazon Cognito ID token encoded: ${sessionStorage.idToken.toString()}`,
  );
  console.log("Amazon Cognito ID token decoded: ");
  console.log(idToken);
  console.log(
    `Amazon Cognito access token encoded: ${sessionStorage.accessToken.toString()}`,
  );
  console.log("Amazon Cognito access token decoded: ");
  console.log(accessToken);
  console.log("Amazon Cognito refresh token: ");
  console.log(sessionStorage.refreshToken);
  console.log(
    "Amazon Cognito example application. Not for use in production applications.",
  );
  const handleLogout = () => {
    sessionStorage.clear();
    navigate("/login");
  };

  
  // added
  const [applications, setApplications] = useState<Application[]>([]);
  
  const user_email = getCurrentUserEmail();
  console.log("user_email: ", user_email);
  
  const [newApp, setNewApp] = useState<Omit<Application, "job_id">>({
    user_id: user_email,
    company: "",
    position: "",
    status: "applied",
    date_applied: new Date().toISOString().split("T")[0],
    notes: "",
    tags: [],
  });
  console.log("newApp: ", newApp);

  useEffect(() => {
    if (!user_email) return;

    const loadApplications = async () => {
      try {
        const apps = await fetchApplications(user_email);
        setApplications(apps);
      } catch (error) {
        console.error("Error fetching applications:", error);
      }
    };

    loadApplications();
  }, [user_email]);



  const handleCreate = async () => {
    try {
      console.log("Creating application:", newApp);
      const created = await createApplication(newApp);
      setApplications((prev) => [...prev, created]);
      setNewApp({ ...newApp, company: "", position: "", notes: "", tags: [] });
    } catch (err) {
      console.error("Error creating app:", err);
    }
  };

  // const handleDelete = async (job_id: string) => {
  //   try {
  //     console.log("Deleting application:", job_id, "of user:", user_email);
  //     await deleteApplication(user_email, job_id);
  //     setApplications((prev) => prev.filter((app) => app.job_id !== job_id));
  //   } catch (err) {
  //     console.error("Error deleting app:", err);
  //   }
  // }



  return (
    <div className="homePage">
      <h2>My Applications</h2>

      <div className="createForm">
        <input
          type="text"
          placeholder="Company"
          value={newApp.company}
          onChange={(e) => setNewApp({ ...newApp, company: e.target.value })}
        />
        <input
          type="text"
          placeholder="Position"
          value={newApp.position}
          onChange={(e) => setNewApp({ ...newApp, position: e.target.value })}
        />
        <input
          type="date"
          value={newApp.date_applied}
          onChange={(e) => setNewApp({ ...newApp, date_applied: e.target.value })}
        />
        <textarea
          placeholder="Notes"
          value={newApp.notes}
          onChange={(e) => setNewApp({ ...newApp, notes: e.target.value })}
        />
        <button onClick={handleCreate}>Add</button>
      </div>
      <button type="button" onClick={handleLogout}>
        Logout
      </button>

      {/* // Display applications */}
      {/* Liste des applications */}
      <ul>
        {applications.map((app) => (
          <li key={app.job_id}>
            <strong>{app.company}</strong> - {app.position} - {app.status}
          </li>
        ))}
      </ul>
      
      
    </div>
  );
};

export default HomePage;