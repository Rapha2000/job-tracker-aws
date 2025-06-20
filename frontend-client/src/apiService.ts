type Application = {
  user_id: string;
  company: string;
  position: string;
  status: string;
  date_applied: string;
  notes: string;
};


const getAuthHeaders = () => {
  const idToken = sessionStorage.idToken.toString()
  const accessToken = sessionStorage.accessToken.toString()

  if (!accessToken) throw new Error("No access token found");
  return {
    "Content-Type": "application/json",
    Authorization: `Bearer ${accessToken}`,
  };
};

// Create a new application for a specific user
export const createApplication = async (app: Application) => {

  const apiUrl = import.meta.env.VITE_API_URL
  
  const res = await fetch(`${apiUrl}/createApplication`, {
    method: "POST",
    headers: getAuthHeaders(),
    body: JSON.stringify(app),
  });

  if (!res.ok) throw new Error("Failed to create application");

  const data = await res.json();
  return data.application;
};

// Delete an existing application
export const deleteApplication = async (user_id: string, job_id: string) => {

  const apiUrl = import.meta.env.VITE_API_URL

  const res = await fetch(`${apiUrl}/deleteApplication`, {
    method: "POST",
    headers: getAuthHeaders(),
    body: JSON.stringify({ user_id, job_id }),
  });

  if (!res.ok) throw new Error("Failed to delete application");
}

// Get the list of applications for a specific user (queryString)
export const fetchApplications = async (user_id : string) => {
  
  const apiUrl = import.meta.env.VITE_API_URL
  
  const res = await fetch(
    `${apiUrl}/applications?user_id=${encodeURIComponent(user_id)}`,
    {
      method: "GET",
      headers: getAuthHeaders(),
    }
  );
  if (!res.ok) throw new Error("Failed to fetch applications");

  const data = await res.json();
  return data.applications;
}

// Update an existing application
export const updateApplication = async (
  user_id: string,
  job_id: string,
  updates: Partial<Omit<Application, "user_id" | "job_id">>
) => {
  const payload = { user_id, job_id, ...updates };

  const apiUrl = import.meta.env.VITE_API_URL

  const res = await fetch(`${apiUrl}/updateApplication`, {
    method: "PUT",
    headers: getAuthHeaders(),
    body: JSON.stringify(payload),
  });

  if (!res.ok) throw new Error("Failed to update application");
};