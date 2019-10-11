var N = $("input#N")
var TABLE = $("table#input > tbody")
var CANVAS = $("#result_img")
var canvas = CANVAS.get()[0];
var list = [], ranked
var xborder, yborder

N.on("input", evt => {
  if (parseInt(N.val()) > TABLE.children().length) {
    for (var i = TABLE.children().length; i < parseInt(N.val()); i++) TABLE.append(`<tr>\n<th scope="row">${i + 1}</th>\n<td><input type="text" class="form-control" value="${Math.floor((Math.random() - 0.5) * 50)}"></td>\n<td><input type="text" class="form-control" value="${Math.floor((Math.random() - 0.5) * 50)}"></td>\n</tr>`)
  } else {
    for (var i = TABLE.children().length - 1; i >= parseInt(N.val()); i--) TABLE.children()[i].remove()
  }
})

function makeList() {
  list = []
  TABLE.children().toArray().forEach(ele => {
    let point = ele.querySelectorAll("input")
    let index = ele.querySelector("th").innerText
    list.push({ x: parseInt(point[0].value), y: parseInt(point[1].value), index: parseInt(index), rank: 0 })
  })
  list.sort((a, b) => {
    if (a.x != b.x) return a.x - b.x
    else return a.y - b.y
  })
}

function makePoints() {
  TABLE.children().toArray().forEach(ele => {
    let point = ele.querySelectorAll("input")
    point[0].value = Math.floor((Math.random() - 0.5) * 1000)
    point[1].value = Math.floor((Math.random() - 0.5) * 1000)
  })
}

function ranking(l) {
  if (l.length <= 1) return l
  let left = ranking(l.slice(0, Math.floor(l.length / 2)))
  let right = ranking(l.slice(Math.floor(l.length / 2), l.length))
  right.forEach(ele_r => {
    left.forEach(ele_l => {
      if (ele_r.x > ele_l.x && ele_r.y > ele_l.y) ele_r.rank++
    })
  })
  return left.concat(right)
}

function start() {
  makeList()
  ranked = ranking(list)
  ranked.sort((a, b) => { return a.index - b.index });
  console.log(ranked)
  let xmin = Number.MAX_VALUE, xmax = Number.MIN_VALUE, ymin = Number.MAX_VALUE, ymax = Number.MIN_VALUE
  list.forEach(ele => {
    if (xmin > ele.x) xmin = ele.x
    if (ymin > ele.y) ymin = ele.y
    if (xmax < ele.x) xmax = ele.x
    if (ymax < ele.y) ymax = ele.y
  })
  let xb = (Math.abs(xmin) > Math.abs(xmax)) ? Math.abs(xmin) : Math.abs(xmax)
  let yb = (Math.abs(ymin) > Math.abs(ymax)) ? Math.abs(ymin) : Math.abs(ymax)
  let xbr = xb, ybr = yb
  while (xb > 10) xb /= 10
  while (yb > 10) yb /= 10
  drawList(ranked, Math.floor(Math.ceil(xb) * xbr / xb), Math.floor(Math.ceil(yb) * ybr / yb))
  $("#result_table > tbody").get()[0].innerHTML = ""
  ranked.forEach(ele=>{
    $("#result_table > tbody").get()[0].innerHTML += `<tr><th scope="row">${ele.index}</th><td>${ele.x}</td><td>${ele.y}</td><td>${ele.rank}</td>`
  })
  $('#result').modal('show')
}

function drawList(l, xb, yb) {
  xborder = xb, yborder = yb
  var ctx = canvas.getContext('2d')
  ctx.clearRect(0, 0, canvas.width, canvas.height)
  ctx.font = '12px sans-serif';
  ctx.beginPath()
  ctx.moveTo(0, canvas.height / 2)
  ctx.lineTo(canvas.width, canvas.height / 2)
  ctx.moveTo(canvas.width / 2, 0)
  ctx.lineTo(canvas.width / 2, canvas.height)
  ctx.closePath()
  ctx.stroke()
  ctx.fillText(yb, canvas.width / 2 + 3, 12)
  ctx.fillText(-yb, canvas.width / 2 + 3, canvas.height)
  ctx.fillText(-xb, 0, canvas.height / 2 - 3)
  ctx.textAlign = 'right'
  ctx.fillText(xb, canvas.width, canvas.height / 2 - 3)
  ctx.textAlign = 'left'
  l.forEach(ele => {
    let x = (ele.x + xb) / xb / 2 * canvas.width, y = canvas.height - (ele.y + yb) / yb / 2 * canvas.height
    ctx.beginPath()
    ctx.arc(x, y, 2, 0, 2 * Math.PI, true)
    if (x + 50 > canvas.width && y - 30 < 0) {
      ctx.textAlign = 'right'
      ctx.fillText(`(${ele.x},${ele.y})`, x - 5, y + 12)
      ctx.fillText(`Rank: ${ele.rank}`, x - 5, y + 30)
    } else if (x + 50 > canvas.width) {
      ctx.textAlign = 'right'
      ctx.fillText(`(${ele.x},${ele.y})`, x - 5, y)
      ctx.fillText(`Rank: ${ele.rank}`, x - 5, y-15)
    } else if (y - 30 < 0) {
      ctx.textAlign = 'left'
      ctx.fillText(`(${ele.x},${ele.y})`, x + 5, y + 12)
      ctx.fillText(`Rank: ${ele.rank}`, x + 5, y + 30)
    } else {
      ctx.textAlign = 'left'
      ctx.fillText(`(${ele.x},${ele.y})`, x + 5, y)
      ctx.fillText(`Rank: ${ele.rank}`, x + 5, y -15)
    }
    ctx.fill()
  })
}

$(window).resize(() => {
  canvas.width = window.innerWidth * 0.5
  canvas.height = window.innerHeight * 0.5
  drawList(ranked, xborder, yborder)
  CANVAS.modal('handleUpdate')
})
canvas.width = window.innerWidth * 0.5
canvas.height = window.innerHeight * 0.5
CANVAS.modal('handleUpdate')
