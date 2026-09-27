---
layout: default
title: "Rednote Statistics"
description: "Interactive statistics and growth trends for my Rednote follower data."
permalink: /rednote/
author_profile: false
---

<span class="anchor" id="rednote-followers"></span>
# 📕 Rednote Followers

<div id="fans-wrapper">
  <div id="rednote-status" class="rednote-status rednote-status--loading" role="status">Loading Rednote data...</div>

  <div class="fans-card-grid">
    <div class="fans-card" id="card-total"></div>
    <div class="fans-card" id="card-yesterday"></div>
    <div class="fans-card" id="card-7d"></div>
    <div class="fans-card" id="card-30d"></div>
    <div class="fans-card" id="card-maxday"></div>
    <div class="fans-card" id="card-growthrate"></div>
    <div class="fans-card" id="card-days"></div>
  </div>

  <div class="rednote-controls">
    <div class="rednote-control-group" id="range-buttons" aria-label="Time range">
      <button type="button" data-range="7" onclick="setRange(7)">Last 7 Days</button>
      <button type="button" data-range="30" onclick="setRange(30)">Last 30 Days</button>
      <button type="button" data-range="all" class="active" onclick="setRange(null)">All</button>
    </div>

    <div class="rednote-control-group" id="year-buttons" aria-label="Year"></div>

    <div class="rednote-control-group" id="chart-buttons" aria-label="Chart type">
      <button type="button" data-chart="total" class="active" onclick="switchChart('total')">Total Followers</button>
      <button type="button" data-chart="daily" onclick="switchChart('daily')">Daily Growth</button>
      <button type="button" data-chart="rate" onclick="switchChart('rate')">Growth Rate (%)</button>
    </div>

    <button type="button" id="download-csv" class="rednote-download-button" disabled>Download CSV</button>
  </div>

  <div class="rednote-chart-box">
    <canvas id="fansChart"></canvas>
  </div>
</div>

<style>
  .archive,
  .page {
    width: 100% !important;
    max-width: 100% !important;
  }

  #fans-wrapper {
    --rednote-milestone-color: rgba(201, 91, 99, 0.88);
    --rednote-milestone-line: rgba(201, 91, 99, 0.38);
    --rednote-grid-line: rgba(75, 98, 92, 0.18);
    max-width: 100%;
    margin: 0 auto;
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
  }

  .rednote-status {
    margin-bottom: 14px;
    padding: 10px 12px;
    border: 1px solid rgba(125, 181, 168, 0.35);
    border-radius: 6px;
    background: rgba(125, 181, 168, 0.08);
    color: #4b625c;
    font-size: 0.9rem;
  }

  .rednote-status--error {
    border-color: rgba(207, 10, 36, 0.35);
    background: rgba(207, 10, 36, 0.08);
    color: #a20e24;
  }

  .rednote-status--success {
    color: #4b625c;
  }

  .fans-card-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(145px, 1fr));
    gap: 10px;
    margin-bottom: 14px;
  }

  .fans-card {
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    min-width: 0;
    min-height: 72px;
    background: white;
    border-radius: 8px;
    box-shadow: 0 6px 20px rgba(0, 0, 0, 0.05);
    padding: 10px 12px;
    color: #333;
    font-size: 0.78rem;
    line-height: 1.25;
  }

  .fans-card span {
    display: block;
    font-weight: bold;
    font-size: 1.15rem;
    line-height: 1.2;
    margin-top: 5px;
    color: rgb(125, 181, 168);
    overflow-wrap: anywhere;
  }

  .rednote-controls {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 10px;
    margin-bottom: 12px;
  }

  .rednote-control-group {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
  }

  #chart-buttons {
    margin-left: 10px;
    padding-left: 18px;
    border-left: 1px solid rgba(75, 98, 92, 0.18);
  }

  #fans-wrapper button {
    border: none;
    background: rgba(125, 181, 168, 0.65);
    color: white;
    border-radius: 6px;
    padding: 6px 12px;
    cursor: pointer;
    font-size: 0.9rem;
  }

  #fans-wrapper button:hover,
  #fans-wrapper button.active {
    background: rgb(105, 161, 148);
    font-weight: bold;
  }

  #fans-wrapper button:disabled {
    cursor: not-allowed;
    opacity: 0.55;
  }

  .rednote-download-button {
    margin-left: auto;
  }

  .rednote-chart-box {
    height: 440px;
  }

  #fansChart {
    width: 100%;
    height: 440px;
  }

  html[data-theme="dark"] .rednote-status {
    border-color: #30363d;
    background: #161b22;
    color: #d8dee9;
  }

  html[data-theme="dark"] .rednote-status--error {
    border-color: rgba(207, 10, 36, 0.55);
    color: #ff8d9d;
  }

  html[data-theme="dark"] #fans-wrapper {
    --rednote-milestone-color: rgba(224, 122, 132, 0.9);
    --rednote-milestone-line: rgba(224, 122, 132, 0.44);
    --rednote-grid-line: rgba(216, 222, 233, 0.16);
  }

  html[data-theme="dark"] #fans-wrapper button {
    background: #273c38;
  }

  html[data-theme="dark"] #fans-wrapper button:hover,
  html[data-theme="dark"] #fans-wrapper button.active {
    background: #7db5a8;
    color: #0d1117;
  }

  html[data-theme="dark"] #chart-buttons {
    border-left-color: rgba(216, 222, 233, 0.18);
  }

  @media (max-width: 760px) {
    #chart-buttons {
      margin-left: 0;
      padding-left: 0;
      border-left: 0;
    }
  }

  @media (max-width: 520px) {
    .rednote-download-button {
      margin-left: 0;
      width: 100%;
    }
  }
</style>

<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.9/dist/chart.umd.min.js"></script>

<script>
  const SHEET_CSV_URL = 'https://docs.google.com/spreadsheets/d/e/2PACX-1vQUX3jbmcxIjz_VyFAy33PJzbYPVKPVXIEOSMdoy7bqRPOl-y1n-lZe8pkZ55WYwkQaqGEAQ0D_idrc/pub?output=csv';
  const FALLBACK_CSV_URL = '{{ "/backup/rednote-followers-latest.csv" | relative_url }}';
  const REDNOTE_DATA_SOURCES = [
    { url: SHEET_CSV_URL, name: 'live' },
    { url: FALLBACK_CSV_URL, name: 'snapshot' }
  ];
  const rednoteRequestTimeout = 8000;
  const chartColor = 'rgba(125,181,168,0.95)';
  const fillColor = 'rgba(125,181,168,0.25)';
  const numberFormatter = new Intl.NumberFormat('en-US');
  const lineAnimationDuration = 850;
  const milestoneAnimationDelay = 140;
  const milestoneAnimationDuration = 1250;
  const minChartPixelRatio = 2;
  const maxChartPixelRatio = 4;

  let chart;
  let chartPixelRatioFrame = null;
  let rawCsvText = '';
  let totalData = [];
  let dailyData = [];
  let rateData = [];
  let labels = [];
  let milestones = [];
  let chartType = 'total';
  let rangeLimit = null;
  let selectedYear = null;

  const milestonePlugin = {
    id: 'rednoteMilestones',
    afterDatasetsDraw(chartInstance, args, pluginOptions) {
      const shownMilestones = (pluginOptions && pluginOptions.milestones) || [];
      if (!shownMilestones.length) return;

      const { ctx, chartArea, scales } = chartInstance;
      const xScale = scales.x;
      const yScale = scales.y;
      const visibleLabels = chartInstance.data.labels || [];
      const progress = getMilestoneAnimationProgress(chartInstance);

      ctx.save();
      shownMilestones.forEach((milestone) => {
        const milestoneColor = getMilestoneColor();
        const milestoneLineColor = getMilestoneLineColor();
        const visibleIndex = visibleLabels.indexOf(milestone.date);
        if (visibleIndex === -1) return;

        const x = xScale.getPixelForValue(visibleIndex);
        const y = yScale.getPixelForValue(milestone.count);
        if (!Number.isFinite(x) || !Number.isFinite(y)) return;

        const targetTopY = y - 1.5;
        const animatedTopY = chartArea.bottom - (chartArea.bottom - targetTopY) * progress;
        drawMilestoneStem(ctx, x, animatedTopY, chartArea.bottom, milestoneLineColor);

        const labelProgress = clamp((progress - 0.45) / 0.55);
        if (labelProgress <= 0) return;

        ctx.save();
        ctx.globalAlpha = labelProgress;
        drawStar(ctx, x, animatedTopY - 5.5, 6, milestoneColor);
        ctx.fillStyle = milestoneColor;
        ctx.font = '700 10px -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText(numberFormatter.format(milestone.threshold), x, animatedTopY - 15.5);

        ctx.save();
        ctx.translate(x, chartArea.bottom + 28);
        ctx.rotate(-Math.PI / 4);
        ctx.textAlign = 'right';
        ctx.fillText(milestone.date, 0, 0);
        ctx.restore();
        ctx.restore();
      });
      ctx.restore();

      if (progress < 1) requestMilestoneFrame(chartInstance);
    }
  };

  function resetMilestoneAnimation(chartInstance) {
    chartInstance.$rednoteMilestoneStart = performance.now();
    chartInstance.$rednoteMilestoneFrame = null;
  }

  function getMilestoneAnimationProgress(chartInstance) {
    const start = chartInstance.$rednoteMilestoneStart || performance.now();
    const elapsed = performance.now() - start - milestoneAnimationDelay;
    return easeOutCubic(clamp(elapsed / milestoneAnimationDuration));
  }

  function requestMilestoneFrame(chartInstance) {
    if (chartInstance.$rednoteMilestoneFrame) return;

    chartInstance.$rednoteMilestoneFrame = requestAnimationFrame(() => {
      chartInstance.$rednoteMilestoneFrame = null;
      if (chart === chartInstance) chartInstance.draw();
    });
  }

  function clamp(value, min = 0, max = 1) {
    return Math.min(max, Math.max(min, value));
  }

  function easeOutCubic(value) {
    return 1 - Math.pow(1 - value, 3);
  }

  function getChartPixelRatio() {
    return clamp(window.devicePixelRatio || 1, minChartPixelRatio, maxChartPixelRatio);
  }

  function scheduleChartPixelRatioRefresh() {
    if (!chart || chartPixelRatioFrame) return;

    chartPixelRatioFrame = requestAnimationFrame(() => {
      chartPixelRatioFrame = null;
      if (!chart) return;

      chart.options.devicePixelRatio = getChartPixelRatio();
      chart.resize();
      chart.update('none');
    });
  }

  function drawMilestoneStem(ctx, x, topY, bottomY, color) {
    const height = bottomY - topY;
    if (height <= 0) return;

    const topWidth = 2.4;
    const bottomWidth = 8.2;
    const topHalf = topWidth / 2;
    const bottomHalf = bottomWidth / 2;

    ctx.save();
    ctx.beginPath();
    ctx.moveTo(x - topHalf, topY);
    ctx.bezierCurveTo(
      x - topHalf * 0.72,
      topY + height * 0.28,
      x - bottomHalf * 0.62,
      topY + height * 0.74,
      x - bottomHalf,
      bottomY
    );
    ctx.lineTo(x + bottomHalf, bottomY);
    ctx.bezierCurveTo(
      x + bottomHalf * 0.62,
      topY + height * 0.74,
      x + topHalf * 0.72,
      topY + height * 0.28,
      x + topHalf,
      topY
    );
    ctx.lineTo(x - topHalf, topY);
    ctx.closePath();
    ctx.fillStyle = color;
    ctx.fill();
    ctx.restore();
  }

  function drawStar(ctx, x, y, radius, color) {
    ctx.save();
    ctx.beginPath();
    for (let i = 0; i < 10; i++) {
      const angle = -Math.PI / 2 + i * Math.PI / 5;
      const pointRadius = i % 2 === 0 ? radius : radius * 0.45;
      const px = x + Math.cos(angle) * pointRadius;
      const py = y + Math.sin(angle) * pointRadius;
      if (i === 0) ctx.moveTo(px, py);
      else ctx.lineTo(px, py);
    }
    ctx.closePath();
    ctx.fillStyle = color;
    ctx.fill();
    ctx.restore();
  }

  function getMilestoneColor() {
    return getComputedStyle(document.getElementById('fans-wrapper'))
      .getPropertyValue('--rednote-milestone-color')
      .trim() || '#c95b63';
  }

  function getMilestoneLineColor() {
    return getComputedStyle(document.getElementById('fans-wrapper'))
      .getPropertyValue('--rednote-milestone-line')
      .trim() || 'rgba(201, 91, 99, 0.46)';
  }

  function getGridLineColor() {
    return getComputedStyle(document.getElementById('fans-wrapper'))
      .getPropertyValue('--rednote-grid-line')
      .trim() || 'rgba(75, 98, 92, 0.18)';
  }

  function setStatus(message, type = 'loading') {
    const status = document.getElementById('rednote-status');
    status.textContent = message;
    status.className = `rednote-status rednote-status--${type}`;
  }

  async function fetchCsvData() {
    let lastError;

    for (const source of REDNOTE_DATA_SOURCES) {
      const controller = typeof AbortController === 'function' ? new AbortController() : null;
      const timeoutId = controller ? setTimeout(() => controller.abort(), rednoteRequestTimeout) : null;

      try {
        const response = await fetch(source.url, {
          cache: 'no-store',
          signal: controller ? controller.signal : undefined
        });
        if (!response.ok) throw new Error(`HTTP ${response.status}`);

        const text = await response.text();
        if (!text.trim()) throw new Error('Empty CSV response');
        return { text, source: source.name };
      } catch (error) {
        lastError = error;
      } finally {
        if (timeoutId) clearTimeout(timeoutId);
      }
    }

    throw lastError || new Error('No Rednote data source available');
  }

  async function fetchData() {
    setStatus('Loading Rednote data...', 'loading');
    document.getElementById('download-csv').disabled = true;

    try {
      const loaded = await fetchCsvData();
      rawCsvText = loaded.text;
      const rows = parseCsv(rawCsvText);
      const parsedRows = parseFollowerRows(rows);
      if (!parsedRows.length) throw new Error('No valid date/count rows found.');

      labels = parsedRows.map(row => row.date);
      totalData = parsedRows.map(row => row.count);
      dailyData = [0];
      rateData = [0];

      for (let i = 1; i < totalData.length; i++) {
        const diff = totalData[i] - totalData[i - 1];
        dailyData.push(diff);
        rateData.push(totalData[i - 1] ? parseFloat(((diff / totalData[i - 1]) * 100).toFixed(2)) : 0);
      }

      milestones = buildMilestones(totalData, labels);
      renderYearButtons();
      updateStats();
      document.getElementById('download-csv').disabled = false;
      const sourceLabel = loaded.source === 'live' ? 'Live Google Sheet' : 'Saved snapshot';

      if (typeof Chart !== 'function') {
        setStatus(`Data loaded from ${sourceLabel}, but the chart library is unavailable.`, 'error');
        return;
      }

      drawChart(chartType);
      setStatus(`Last updated: ${labels.at(-1)} · ${labels.length} days tracked · ${sourceLabel}`, 'success');
    } catch (error) {
      console.error(error);
      setStatus(`Failed to load Rednote data. ${error.message}`, 'error');
    }
  }

  function parseCsv(text) {
    const rows = [];
    let row = [];
    let cell = '';
    let inQuotes = false;

    for (let i = 0; i < text.length; i++) {
      const char = text[i];
      const nextChar = text[i + 1];

      if (char === '"' && inQuotes && nextChar === '"') {
        cell += '"';
        i += 1;
      } else if (char === '"') {
        inQuotes = !inQuotes;
      } else if (char === ',' && !inQuotes) {
        row.push(cell);
        cell = '';
      } else if ((char === '\n' || char === '\r') && !inQuotes) {
        if (char === '\r' && nextChar === '\n') i += 1;
        row.push(cell);
        rows.push(row);
        row = [];
        cell = '';
      } else {
        cell += char;
      }
    }

    if (cell || row.length) {
      row.push(cell);
      rows.push(row);
    }

    return rows.filter(csvRow => csvRow.some(csvCell => csvCell.trim()));
  }

  function parseFollowerRows(rows) {
    const head = rows[0] || [];
    const dateIdx = head.findIndex(h => h.trim().toLowerCase() === 'date');
    const countIdx = head.findIndex(h => h.trim().toLowerCase() === 'count');

    if (dateIdx === -1 || countIdx === -1) return [];

    return rows.slice(1).map(row => {
      const date = row[dateIdx]?.trim();
      const count = parseInt(String(row[countIdx] || '').replace(/,/g, '').trim(), 10);
      return { date, count };
    }).filter(row => row.date && Number.isFinite(row.count));
  }

  function buildMilestones(counts, dates) {
    const maxCount = Math.max(...counts);
    const result = [];

    for (let threshold = 500; threshold <= maxCount; threshold += 500) {
      const index = counts.findIndex(count => count >= threshold);
      if (index !== -1) {
        result.push({
          threshold,
          index,
          date: dates[index],
          count: counts[index]
        });
      }
    }

    return result;
  }

  function getYearFromLabel(label) {
    const match = String(label || '').match(/^(\d{4})/);
    return match ? match[1] : '';
  }

  function getAvailableYears() {
    return [...new Set(labels.map(getYearFromLabel).filter(Boolean))];
  }

  function renderYearButtons() {
    const yearButtons = document.getElementById('year-buttons');
    const years = getAvailableYears();
    yearButtons.innerHTML = '';

    if (selectedYear && !years.includes(selectedYear)) selectedYear = null;

    years.forEach(year => {
      const button = document.createElement('button');
      button.type = 'button';
      button.dataset.year = year;
      button.textContent = year;
      button.addEventListener('click', () => setYear(year));
      yearButtons.appendChild(button);
    });

    updateYearButtons();
  }

  function updateStats() {
    const latest = totalData.at(-1);
    const yesterday = totalData.at(-2) ?? latest;
    const last7 = totalData.slice(-7);
    const last30 = totalData.slice(-30);
    const sum7 = last7.length > 1 ? last7.at(-1) - last7[0] : 0;
    const sum30 = last30.length > 1 ? last30.at(-1) - last30[0] : 0;
    const recentRates = rateData.slice(-Math.min(7, rateData.length)).filter(Number.isFinite);
    const avgRate7 = recentRates.length ? recentRates.reduce((a, b) => a + b, 0) / recentRates.length : 0;
    const growthOnly = dailyData.slice(1);
    const maxGrowth = growthOnly.length ? Math.max(...growthOnly) : 0;
    const maxIndex = dailyData.findIndex((value, index) => index > 0 && value === maxGrowth);
    const maxDate = labels[maxIndex] || labels.at(-1);

    document.getElementById('card-total').innerHTML = `Total Followers<span>${numberFormatter.format(latest)}</span>`;
    document.getElementById('card-yesterday').innerHTML = `Yesterday's Growth<span>${numberFormatter.format(latest - yesterday)}</span>`;
    document.getElementById('card-7d').innerHTML = `7-Day Growth<span>${numberFormatter.format(sum7)}</span>`;
    document.getElementById('card-30d').innerHTML = `30-Day Growth<span>${numberFormatter.format(sum30)}</span>`;
    document.getElementById('card-maxday').innerHTML = `Max Daily Growth<span>${numberFormatter.format(maxGrowth)} (${maxDate})</span>`;
    document.getElementById('card-growthrate').innerHTML = `Avg 7-Day Rate<span>${avgRate7.toFixed(2)}%</span>`;
    document.getElementById('card-days').innerHTML = `Days Tracked<span>${numberFormatter.format(labels.length)}</span>`;
  }

  function drawChart(type = 'total') {
    chartType = type;
    const fullDataSet = type === 'total' ? totalData : (type === 'daily' ? dailyData : rateData);
    const label = type === 'total' ? 'Total Followers' : (type === 'daily' ? 'Daily Growth' : 'Growth Rate (%)');
    const visibleIndices = getVisibleIndices();
    const dataSet = visibleIndices.map(index => fullDataSet[index]);
    const shownLabels = visibleIndices.map(index => labels[index]);
    const localMax = Math.max(...dataSet);
    const baselineValue = type === 'rate' ? 0 : Math.floor(Math.min(...dataSet) * 0.95);
    const initialDataSet = dataSet.map(() => baselineValue);
    const visibleIndexSet = new Set(visibleIndices);
    const shownMilestones = type === 'total'
      ? milestones.filter(milestone => visibleIndexSet.has(milestone.index))
      : [];

    if (chart) chart.destroy();

    chart = new Chart(document.getElementById('fansChart'), {
      type: 'line',
      data: {
        labels: shownLabels,
        datasets: [{
          label,
          data: initialDataSet,
          borderColor: chartColor,
          backgroundColor: fillColor,
          fill: true,
          tension: 0.3,
          borderWidth: 1.5,
          pointRadius: function(ctx) {
            if ((type === 'daily' || type === 'rate') && ctx.raw === localMax) return 4;
            return 0;
          },
          pointBackgroundColor: function(ctx) {
            if ((type === 'daily' || type === 'rate') && ctx.raw === localMax) return getMilestoneColor();
            return chartColor;
          },
          pointHoverRadius: 5
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        devicePixelRatio: getChartPixelRatio(),
        animation: {
          duration: lineAnimationDuration,
          easing: 'easeOutCubic'
        },
        layout: {
          padding: {
            top: type === 'total' ? 14 : 0,
            bottom: shownMilestones.length ? 62 : 0
          }
        },
        plugins: {
          legend: { display: false },
          rednoteMilestones: { milestones: [] },
          tooltip: {
            backgroundColor: 'rgba(0,0,0,0.8)',
            titleFont: { size: 13 },
            bodyFont: { size: 12 },
            padding: 10,
            callbacks: {
              title: (items) => items[0].label,
              label: (item) => `${item.dataset.label}: ${item.formattedValue}`
            }
          }
        },
        scales: {
          x: {
            ticks: { maxTicksLimit: 10 },
            grid: {
              color: getGridLineColor,
              borderDash: [2, 2],
              tickBorderDash: [2, 2],
              drawTicks: false
            },
            border: {
              color: getGridLineColor,
              dash: [2, 2]
            }
          },
          y: {
            beginAtZero: type === 'rate',
            suggestedMin: type === 'rate' ? 0 : Math.floor(Math.min(...dataSet) * 0.95),
            suggestedMax: Math.ceil(Math.max(...dataSet) * 1.05),
            grid: {
              color: getGridLineColor,
              borderDash: [2, 2],
              tickBorderDash: [2, 2],
              drawTicks: false
            },
            border: {
              color: getGridLineColor,
              dash: [2, 2]
            }
          }
        }
      },
      plugins: [milestonePlugin]
    });

    const chartInstance = chart;
    requestAnimationFrame(() => {
      if (chart !== chartInstance) return;

      chartInstance.data.datasets[0].data = dataSet;
      chartInstance.options.plugins.rednoteMilestones.milestones = shownMilestones;
      resetMilestoneAnimation(chartInstance);
      chartInstance.update();
    });
  }

  function switchChart(viewType) {
    chartType = viewType;
    drawChart(viewType);
    document.querySelectorAll('#chart-buttons button').forEach(btn => {
      btn.classList.toggle('active', btn.dataset.chart === viewType);
    });
  }

  function setRange(days) {
    rangeLimit = days;
    selectedYear = null;
    drawChart(chartType);
    updateRangeButtons();
    updateYearButtons();
  }

  function setYear(year) {
    selectedYear = year;
    rangeLimit = null;
    drawChart(chartType);
    updateRangeButtons();
    updateYearButtons();
  }

  function getVisibleIndices() {
    if (selectedYear) {
      const yearIndices = labels
        .map((label, index) => getYearFromLabel(label) === selectedYear ? index : -1)
        .filter(index => index !== -1);
      if (yearIndices.length) return yearIndices;
    }

    const startIndex = rangeLimit ? Math.max(0, labels.length - rangeLimit) : 0;
    return labels.slice(startIndex).map((label, offset) => startIndex + offset);
  }

  function updateRangeButtons() {
    document.querySelectorAll('#range-buttons button').forEach(btn => {
      const isAll = rangeLimit === null && selectedYear === null && btn.dataset.range === 'all';
      const isMatch = selectedYear === null && btn.dataset.range == rangeLimit;
      btn.classList.toggle('active', isAll || isMatch);
    });
  }

  function updateYearButtons() {
    document.querySelectorAll('#year-buttons button').forEach(btn => {
      btn.classList.toggle('active', btn.dataset.year === selectedYear);
    });
  }

  function downloadCsv() {
    if (!rawCsvText) return;
    const blob = new Blob([rawCsvText], { type: 'text/csv;charset=utf-8' });
    const url = URL.createObjectURL(blob);
    const link = document.createElement('a');
    const today = new Date().toISOString().slice(0, 10);
    link.href = url;
    link.download = `rednote-followers-${today}.csv`;
    document.body.appendChild(link);
    link.click();
    link.remove();
    URL.revokeObjectURL(url);
  }

  document.getElementById('download-csv').addEventListener('click', downloadCsv);
  new MutationObserver(() => {
    if (chart) chart.update();
  }).observe(document.documentElement, { attributes: true, attributeFilter: ['data-theme'] });
  window.addEventListener('resize', scheduleChartPixelRatioRefresh);
  window.addEventListener('DOMContentLoaded', fetchData);
</script>
