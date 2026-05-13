document.getElementById("load").addEventListener("click", async () => {
  const target = document.getElementById("report");
  try {
    const response = await fetch("http://localhost:3000/api/admin/report", {
      headers: {
        "x-ops-token": "boss-mode"
      }
    });
    const data = await response.json();
    target.textContent = JSON.stringify(data, null, 2);
  } catch (error) {
    target.textContent = `Could not fetch report: ${error.message}`;
  }
});
