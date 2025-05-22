// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: Apache-2.0

import { useNavigate } from "react-router-dom";
import React, { use, useEffect, useState } from "react";
import {
  fetchApplications,
  createApplication,
  deleteApplication,
  updateApplication,
} from "./apiService";
import { getCurrentUserEmail } from "./authUtils"; 

const USE_MOCK = false;

const MOCK_APPLICATIONS: Application[] = [
  {
    user_id: "mockuser@example.com",
    job_id: "1",
    company: "Acme Corp",
    position: "Frontend Developer",
    status: "applied",
    date_applied: "2025-05-20",
    notes: "Sent resume via LinkedIn.",
  },
  {
    user_id: "mockuser@example.com",
    job_id: "2",
    company: "Globex Inc",
    position: "Backend Engineer",
    status: "interview",
    date_applied: "2025-05-15",
    notes: "Phone interview scheduled.",
  }
];

const STATUS_OPTIONS = ["applied", "first itw", "second itw", "refused"];

type Application = {
  user_id: string;
  job_id?: string;
  company: string;
  position: string;
  status: string;
  date_applied: string;
  notes: string;
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

  if (!USE_MOCK) {
    const idToken = parseJwt(sessionStorage.idToken.toString());
    const accessToken = parseJwt(sessionStorage.accessToken.toString());
  }
 
  // console.log(
  //   `Amazon Cognito ID token encoded: ${sessionStorage.idToken.toString()}`,
  // );
  // console.log("Amazon Cognito ID token decoded: ");
  // console.log(idToken);
  // console.log(
  //   `Amazon Cognito access token encoded: ${sessionStorage.accessToken.toString()}`,
  // );
  // console.log("Amazon Cognito access token decoded: ");
  // console.log(accessToken);
  // console.log("Amazon Cognito refresh token: ");
  // console.log(sessionStorage.refreshToken);
  // console.log(
  //   "Amazon Cognito example application. Not for use in production applications.",
  // );
  const handleLogout = () => {
    sessionStorage.clear();
    navigate("/login");
  };

  
  const [applications, setApplications] = useState<Application[]>([]);
  
  const user_email = getCurrentUserEmail(USE_MOCK);
  
  const [newApp, setNewApp] = useState<Omit<Application, "job_id">>({
    user_id: user_email,
    company: "",
    position: "",
    status: "applied",
    date_applied: new Date().toISOString().split("T")[0],
    notes: "",
  });

  const [editAppId, setEditAppId] = useState<string | null>(null);
  const [editFormData, setEditFormData] = useState<Partial<Application>>({});

  if (!USE_MOCK) {
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
  } else {
    useEffect(() => {
      if (!user_email) return;

      if (USE_MOCK) {
        setApplications(MOCK_APPLICATIONS);
        return;
      }

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
  }

  const handleCreate = async () => {
    try {
      const created = await createApplication(newApp);
      setApplications((prev) => [...prev, created]);
      setNewApp({ ...newApp, company: "", position: "", notes: "" });
    } catch (err) {
      console.error("Error creating app:", err);
    }
  };

  const handleDelete = async (job_id: string) => {
    try {
      await deleteApplication(user_email, job_id);
      setApplications((prev) => prev.filter((app) => app.job_id !== job_id));
    } catch (err) {
      console.error("Error deleting app:", err);
    }
  }

  const handleEditClick = (app: Application) => {
    setEditAppId(app.job_id!);
    setEditFormData({ ...app });
  };

  const handleSaveClick = async () => {
    if (!editAppId) return;

    try {
      const updates = {
        company: editFormData.company!,
        position: editFormData.position!,
        status: editFormData.status!,
        date_applied: editFormData.date_applied!,
        notes: editFormData.notes!,
      };
      await updateApplication(user_email, editAppId, updates);
      setApplications((prev) =>
        prev.map((app) =>
          app.job_id === editAppId ? { ...app, ...updates } : app
        )
      );
      setEditAppId(null);
      setEditFormData({});
    } catch (err) {
      console.error("Error updating app:", err);
    }
  };

  const handleCancelEdit = () => {
    setEditAppId(null);
    setEditFormData({});
  };

  return (
    <div style={{ padding: "2rem", maxWidth: "1000px", margin: "0 auto", fontFamily: "sans-serif" }}>
      <div style={{ display: "flex", justifyContent: "space-between", marginBottom: "2rem" }}>
        <h2>My Applications</h2>
        <button onClick={handleLogout} style={{ padding: "8px 16px", background: "#444", color: "#fff", border: "none", borderRadius: "4px" }}>
          Logout
        </button>
      </div>

      {/* Create Form */}
      <div
        style={{
          marginBottom: "2rem",
          padding: "1rem",
          border: "1px solid #ddd",
          borderRadius: "8px",
          backgroundColor: "#f9f9f9",
        }}
      >
        <h3 style={{ marginBottom: "1rem" }}>Add New Application</h3>
        <div style={{ display: "flex", flexWrap: "wrap", gap: "1rem" }}>
          <input
            type="text"
            placeholder="Company"
            value={newApp.company}
            onChange={(e) => setNewApp({ ...newApp, company: e.target.value })}
            style={{ flex: "1", padding: "8px", borderRadius: "4px", border: "1px solid #ccc" }}
          />
          <input
            type="text"
            placeholder="Position"
            value={newApp.position}
            onChange={(e) => setNewApp({ ...newApp, position: e.target.value })}
            style={{ flex: "1", padding: "8px", borderRadius: "4px", border: "1px solid #ccc" }}
          />
          <select
            value={newApp.status}
            onChange={(e) => setNewApp({ ...newApp, status: e.target.value })}
          >
            {STATUS_OPTIONS.map((option) => (
              <option key={option} value={option}>
                {option}
              </option>
            ))}
          </select>
          <input
            type="date"
            value={newApp.date_applied}
            onChange={(e) => setNewApp({ ...newApp, date_applied: e.target.value })}
            style={{ padding: "8px", borderRadius: "4px", border: "1px solid #ccc" }}
          />
          <textarea
            placeholder="Notes"
            value={newApp.notes}
            onChange={(e) => setNewApp({ ...newApp, notes: e.target.value })}
            style={{ width: "100%", padding: "8px", borderRadius: "4px", border: "1px solid #ccc", marginTop: "0.5rem" }}
          />
          <button onClick={handleCreate} style={{ padding: "8px 16px", background: "#2c3e50", color: "#fff", border: "none", borderRadius: "4px" }}>
            Add
          </button>
        </div>
      </div>

      {/* Applications Table */}
      <table style={{ width: "100%", borderCollapse: "collapse", fontSize: "14px" }}>
        <thead>
          <tr style={{ background: "#f0f0f0" }}>
            {["Company", "Position", "Status", "Date Applied", "Notes", "Actions"].map((header) => (
              <th key={header} style={{ padding: "10px", borderBottom: "1px solid #ccc", textAlign: "left" }}>
                {header}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {applications.map((app) => (
            <tr key={app.job_id} style={{ borderBottom: "1px solid #eee" }}>
              {editAppId === app.job_id ? (
                <>
                  <td><input value={editFormData.company || ""} onChange={(e) => setEditFormData({ ...editFormData, company: e.target.value })} /></td>
                  <td><input value={editFormData.position || ""} onChange={(e) => setEditFormData({ ...editFormData, position: e.target.value })} /></td>
                  <td><select
                        value={editFormData.status || ""}
                        onChange={(e) => setEditFormData({ ...editFormData, status: e.target.value })}
                      >
                        {STATUS_OPTIONS.map((option) => (
                          <option key={option} value={option}>
                            {option}
                          </option>
                        ))}
                      </select>
                  </td>
                  <td><input type="date" value={editFormData.date_applied || ""} onChange={(e) => setEditFormData({ ...editFormData, date_applied: e.target.value })} /></td>
                  <td><textarea value={editFormData.notes || ""} onChange={(e) => setEditFormData({ ...editFormData, notes: e.target.value })} /></td>
                  <td>
                    <button onClick={handleSaveClick} style={{ marginRight: "6px" }}>Save</button>
                    <button onClick={handleCancelEdit}>Cancel</button>
                  </td>
                </>
              ) : (
                <>
                  <td>{app.company}</td>
                  <td>{app.position}</td>
                  <td>{app.status}</td>
                  <td>{app.date_applied}</td>
                  <td>{app.notes}</td>
                  <td>
                    <button
                      onClick={() => handleEditClick(app)}
                      style={{
                        marginRight: "8px",
                        backgroundColor: "#007bff",
                        color: "#fff",
                        border: "none",
                        padding: "6px 10px",
                        borderRadius: "4px",
                        cursor: "pointer",
                      }}
                    >
                      Edit
                    </button>
                    <button
                      onClick={() => handleDelete(app.job_id!)}
                      style={{
                        backgroundColor: "#dc3545",
                        color: "#fff",
                        border: "none",
                        padding: "6px 10px",
                        borderRadius: "4px",
                        cursor: "pointer",
                      }}
                    >
                      Delete
                    </button>
                  </td>
                </>
              )}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default HomePage;