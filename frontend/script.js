// script.js - Frontend logic for Cloud Log Analyzer

(() => {
  const LOADER_MS = 3200;
  const loader = document.getElementById("loader");
  const app = document.getElementById("app");

  const refreshBtn = document.getElementById("refreshBtn");
  const infoCount = document.getElementById("info-count");
  const warnCount = document.getElementById("warn-count");
  const errorCount = document.getElementById("error-count");
  const lastUpdated = document.getElementById("last-updated");

  const infoCard = document.getElementById("info-card");
  const warnCard = document.getElementById("warn-card");
  const errorCard = document.getElementById("error-card");

  const logsContainer = document.getElementById("logs-container");

  let globalData = {};
  let activeDate = null;
  let activeFilter = null;


  // FETCH LOGS

  async function fetchLogs() {
    try {
      const res = await fetch(API_URL);
      if (!res.ok) throw new Error("Bad API response");

      globalData = await res.json();
      renderGroupedLogs(globalData);
    } catch (err) {
      console.error("fetchLogs failed:", err);

      logsContainer.innerHTML = `
        <div class="log-day">
          <div class="day-header">Error loading logs</div>
          <div style="padding:14px;color:#ff8080">Failed to load logs</div>
        </div>
      `;

      infoCount.textContent =
        warnCount.textContent =
        errorCount.textContent =
          "0";
      lastUpdated.textContent = "Last updated —";
    }
  }


  // Update stats for a given date

  function updateStatsFor(date) {
    const logs = globalData[date] || [];

    let info = 0,
      warn = 0,
      error = 0;

    logs.forEach((log) => {
      const lvl = log.level.toLowerCase();
      if (lvl === "info") info++;
      else if (lvl === "warn") warn++;
      else if (lvl === "error") error++;
    });

    infoCount.textContent = info;
    warnCount.textContent = warn;
    errorCount.textContent = error;
  }


  // Apply filter to a date

  function applyFilter(date) {
    const rows = document.querySelectorAll(
      `.day-logs[data-date="${date}"] tbody tr`
    );

    rows.forEach((row) => {
      const lvl = row.className.replace("level-", "").trim();

      if (activeFilter === null) {
        row.style.display = "";
      } else {
        row.style.display = lvl === activeFilter ? "" : "none";
      }
    });
  }


  // Render grouped logs

  function renderGroupedLogs(data) {
    logsContainer.innerHTML = "";

    const dates = Object.keys(data).sort().reverse();

    if (dates.length === 0) {
      logsContainer.innerHTML = `
        <div class="log-day">
          <div class="day-header">No logs found</div>
          <div style="padding:14px;color:var(--muted)">No logs available yet</div>
        </div>
      `;
      return;
    }

    activeDate = dates[0];
    updateStatsFor(activeDate);

    
    // Render each section
    
    dates.forEach((date) => {
      const logs = data[date];

      const block = document.createElement("div");
      block.className = "log-day";

      const header = document.createElement("div");
      header.className = "day-header";
      header.innerHTML = `
        <span>${date}</span>
        <span class="arrow">▼</span>
      `;

      const wrapper = document.createElement("div");
      wrapper.className = "day-logs hidden";
      wrapper.setAttribute("data-date", date);


      // Build table
      let html = `
        <table class="inner-table">
          <thead>
            <tr>
              <th>Time</th>
              <th>Level</th>
              <th>Message</th>
            </tr>
          </thead>
          <tbody>
      `;

      logs.forEach((log) => {
        html += `
          <tr class="level-${log.level.toLowerCase()}">
            <td>${log.time}</td>
            <td>${log.level}</td>
            <td>${log.message}</td>
          </tr>
        `;
      });

      html += "</tbody></table>";
      wrapper.innerHTML = html;

      block.appendChild(header);
      block.appendChild(wrapper);
      logsContainer.appendChild(block);

      header.addEventListener("click", () => {
        const isOpen = header.classList.toggle("open");
        wrapper.classList.toggle("hidden");
        header.querySelector(".arrow").textContent = isOpen ? "▲" : "▼";

        if (isOpen) {
          activeDate = date;
          updateStatsFor(date);
          applyFilter(date);
        }
      });
    });

    applyFilter(activeDate);
    lastUpdated.textContent = "Last updated: " + new Date().toLocaleString();
  }

  
  // Filter button logic

  function toggleFilter(type) {
    if (activeFilter === type) {
      activeFilter = null;
      infoCard.classList.remove("active-filter");
      warnCard.classList.remove("active-filter");
      errorCard.classList.remove("active-filter");
    } else {
      activeFilter = type;

      infoCard.classList.toggle("active-filter", type === "info");
      warnCard.classList.toggle("active-filter", type === "warn");
      errorCard.classList.toggle("active-filter", type === "error");
    }

    applyFilter(activeDate);
  }

  infoCard.addEventListener("click", () => toggleFilter("info"));
  warnCard.addEventListener("click", () => toggleFilter("warn"));
  errorCard.addEventListener("click", () => toggleFilter("error"));


  // INIT
  
  setTimeout(async () => {
    loader.classList.add("hidden");
    app.classList.remove("hidden");
    await fetchLogs();
  }, LOADER_MS);

  refreshBtn.addEventListener("click", fetchLogs);
})();
