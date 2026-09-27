<span class="anchor" id="rednote-followers"></span>
# 📕 Rednote Followers

<!-- 小红书粉丝统计可视化 -->
<div id="fans-wrapper" style="max-width: 800px; margin: 0 auto; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;">
  <!-- 卡片统计区 -->
  <div style="display: flex; gap: 12px; flex-wrap: wrap; justify-content: space-between; margin-bottom: 16px;">
    <div class="fans-card" id="card-total"></div>
    <div class="fans-card" id="card-yesterday"></div>
    <div class="fans-card" id="card-7d"></div>
    <div class="fans-card" id="card-30d"></div>
    <div class="fans-card" id="card-maxday"></div>
    <div class="fans-card" id="card-growthrate"></div>
  </div>

  <!-- 时间范围按钮 -->
  <div style="margin-bottom: 10px;" id="range-buttons">
  <button data-range="7" onclick="setRange(7)">Last 7 Days</button>
  <button data-range="30" onclick="setRange(30)">Last 30 Days</button>
  <button data-range="all" onclick="setRange(null)">All</button>
  </div>

  <!-- 图表切换按钮 -->
  <div style="margin-bottom: 10px;" id="chart-buttons">
  <button data-chart="total" onclick="switchChart('total')">Total Followers</button>
  <button data-chart="daily" onclick="switchChart('daily')">Daily Growth</button>
  <button data-chart="rate" onclick="switchChart('rate')">Growth Rate (%)</button>
  </div>

  <!-- 图表容器 -->
  <div style="height: 240px;">
    <canvas id="fansChart" style="width: 100%; height: 240px;"></canvas>
  </div>
</div>

<style>
  .fans-card {
    flex: 1;
    min-width: 160px;
    background: white;
    border-radius: 16px;
    box-shadow: 0 6px 20px rgba(0,0,0,0.05);
    padding: 14px 18px;
    color: #333;
    font-size: 0.9rem;
  }

  .fans-card span {
    display: block;
    font-weight: bold;
    font-size: 1.5rem;
    margin-top: 6px;
    color: rgb(125,181,168);
  }

  button {
    border: none;
    background: rgba(125,181,168,0.65);
    color: white;
    border-radius: 6px;
    padding: 6px 12px;
    margin-right: 10px;
    cursor: pointer;
    font-size: 0.9rem;
  }

  button:hover {
    background: rgb(105,161,148);
  }

  button.active {
    background: rgb(105,161,148);
    font-weight: bold;
  }
</style>

<!-- 引入 Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
  const SHEET_CSV_URL = 'https://docs.google.com/spreadsheets/d/e/2PACX-1vQUX3jbmcxIjz_VyFAy33PJzbYPVKPVXIEOSMdoy7bqRPOl-y1n-lZe8pkZ55WYwkQaqGEAQ0D_idrc/pub?output=csv';
  const chartColor = 'rgba(125,181,168,0.95)';
  const fillColor = 'rgba(125,181,168,0.25)';
  let chart, totalData = [], dailyData = [], rateData = [], labels = [];
  let chartType = 'total';
  let rangeLimit = null;

  async function fetchData() {
    const res = await fetch(SHEET_CSV_URL);
    const text = await res.text();
    const rows = text.trim().split(/\r?\n/).map(line => line.split(','));
    const head = rows[0];
    const dateIdx = head.findIndex(h => h.trim().toLowerCase() === 'date');
    const countIdx = head.findIndex(h => h.trim().toLowerCase() === 'count');
    const dates = [], counts = [];

    for (let i = 1; i < rows.length; i++) {
      const date = rows[i][dateIdx]?.trim();
      const count = parseInt(rows[i][countIdx]?.trim(), 10);
      if (date && !isNaN(count)) {
        dates.push(date);
        counts.push(count);
      }
    }

    labels = dates;
    totalData = counts;
    dailyData = [0];
    rateData = [0];
    for (let i = 1; i < counts.length; i++) {
      const diff = counts[i] - counts[i - 1];
      dailyData.push(diff);
      rateData.push(parseFloat(((diff / counts[i - 1]) * 100).toFixed(2)));
    }

    updateStats();
    drawChart(chartType);
  }

  function updateStats() {
    const latest = totalData.at(-1);
    const yesterday = totalData.at(-2);
    const last7 = totalData.slice(-7);
    const last30 = totalData.slice(-30);
    const sum7 = last7.at(-1) - last7[0];
    const sum30 = last30.at(-1) - last30[0];
    const avgRate7 = rateData.slice(-7).reduce((a, b) => a + b, 0) / 7;

    const maxGrowth = Math.max(...dailyData);
    const maxIndex = dailyData.findIndex(x => x === maxGrowth);
    const maxDate = labels[maxIndex];

    document.getElementById('card-total').innerHTML = `Total Followers<span>${latest}</span>`;
    document.getElementById('card-yesterday').innerHTML = `Yesterday's Growth<span>${latest - yesterday}</span>`;
    document.getElementById('card-7d').innerHTML = `7-Day Growth<span>${sum7}</span>`;
    document.getElementById('card-30d').innerHTML = `30-Day Growth<span>${sum30}</span>`;
    document.getElementById('card-maxday').innerHTML = `Max Daily Growth<span>${maxGrowth} (${maxDate})</span>`;
    document.getElementById('card-growthrate').innerHTML = `Avg 7-Day Rate<span>${avgRate7.toFixed(2)}%</span>`;
  }

  function drawChart(type = 'total') {
    chartType = type;
    const fullDataSet = type === 'total' ? totalData : (type === 'daily' ? dailyData : rateData);
    const label = type === 'total' ? 'Total Followers' : (type === 'daily' ? 'Daily Growth' : 'Growth Rate (%)');
    const fullLabels = labels;

    const dataSet = rangeLimit ? fullDataSet.slice(-rangeLimit) : fullDataSet;
    const shownLabels = rangeLimit ? fullLabels.slice(-rangeLimit) : fullLabels;
    const localMax = Math.max(...dataSet);

    if (chart) chart.destroy();

    chart = new Chart(document.getElementById('fansChart'), {
      type: 'line',
      data: {
        labels: shownLabels,
        datasets: [{
          label: label,
          data: dataSet,
          borderColor: chartColor,
          backgroundColor: fillColor,
          fill: true,
          tension: 0.3,
          borderWidth: 1.5,
          pointRadius: function(ctx) {
            if ((type === 'daily' || type === 'rate') && ctx.raw === localMax) {
              return 4;
            }
            return 0;
          },
          pointBackgroundColor: function(ctx) {
            if ((type === 'daily' || type === 'rate') && ctx.raw === localMax) {
              return 'rgb(207, 10, 36)';
            }
            return chartColor;
          },
          pointHoverRadius: 5
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: { display: false },
          tooltip: {
            backgroundColor: 'rgba(0,0,0,0.8)',
            titleFont: { size: 13 },
            bodyFont: { size: 12 },
            padding: 10,
            callbacks: {
              title: (items) => '📅 ' + items[0].label,
              label: (item) => '📈 ' + item.dataset.label + ': ' + item.formattedValue
            }
          }
        },
        scales: {
          x: { ticks: { maxTicksLimit: 10 } },
          y: {
            beginAtZero: (type === 'rate'),
            suggestedMin: (type === 'rate') ? 0 : Math.floor(Math.min(...dataSet) * 0.95),
            suggestedMax: Math.ceil(Math.max(...dataSet) * 1.05)
          }
        }
      }
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
  drawChart(chartType);
  document.querySelectorAll('#range-buttons button').forEach(btn => {
    const isAll = days === null && btn.dataset.range === 'all';
    const isMatch = btn.dataset.range == days;
    btn.classList.toggle('active', isAll || isMatch);
  });
  }

  window.addEventListener('DOMContentLoaded', fetchData);
</script>
