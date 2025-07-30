import { useState, useEffect } from 'react';

export default function Home() {
  const [users, setUsers] = useState([]);
  const [apiStatus, setApiStatus] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // Check API health
    fetch('/api/health')
      .then(res => res.json())
      .then(data => setApiStatus(data))
      .catch(err => console.error('API health check failed:', err));

    // Fetch users
    fetch('/api/users')
      .then(res => res.json())
      .then(data => {
        setUsers(data);
        setLoading(false);
      })
      .catch(err => {
        console.error('Failed to fetch users:', err);
        setLoading(false);
      });
  }, []);

  return (
    <div style={{ padding: '2rem', fontFamily: 'Arial, sans-serif' }}>
      <h1>Two Servers POC</h1>
      <p>This demonstrates Express.js and Next.js running in a single container with nginx.</p>
      
      <div style={{ marginBottom: '2rem', padding: '1rem', backgroundColor: '#f5f5f5', borderRadius: '8px' }}>
        <h2>API Status</h2>
        {apiStatus ? (
          <div>
            <p><strong>Status:</strong> {apiStatus.status}</p>
            <p><strong>Message:</strong> {apiStatus.message}</p>
            <p><strong>Port:</strong> {apiStatus.port}</p>
            <p><strong>Timestamp:</strong> {apiStatus.timestamp}</p>
          </div>
        ) : (
          <p>Loading API status...</p>
        )}
      </div>

      <div>
        <h2>Users from Express API</h2>
        {loading ? (
          <p>Loading users...</p>
        ) : users.length > 0 ? (
          <ul style={{ listStyle: 'none', padding: 0 }}>
            {users.map(user => (
              <li key={user.id} style={{ 
                margin: '0.5rem 0', 
                padding: '1rem', 
                backgroundColor: '#e8f4fd', 
                borderRadius: '4px' 
              }}>
                <strong>{user.name}</strong> - {user.email}
              </li>
            ))}
          </ul>
        ) : (
          <p>No users found</p>
        )}
      </div>

      <div style={{ marginTop: '2rem', padding: '1rem', backgroundColor: '#fff3cd', borderRadius: '8px' }}>
        <h3>Architecture</h3>
        <ul>
          <li>Next.js frontend (this page) served on port 3000</li>
          <li>Express.js API server on port 3001</li>
          <li>nginx reverse proxy routing requests</li>
          <li>All running in a single Docker container</li>
        </ul>
      </div>
    </div>
  );
}