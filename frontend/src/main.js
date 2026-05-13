(async () => {
  const target = document.getElementById("status");
  try {
    const response = await fetch("http://localhost:3000/api/status");
    const data = await response.json();
    target.textContent = JSON.stringify(data, null, 2);
  } catch (error) {
    target.textContent = `Could not reach backend: ${error.message}`;
  }
})();
