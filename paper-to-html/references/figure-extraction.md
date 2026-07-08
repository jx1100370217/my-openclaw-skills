# 配图提取手册（从 PDF 精准裁出论文配图）

目标：把论文里的每一张配图（含由多子图拼成的复合图、带坐标轴的曲线图、系统框图）裁成干净 PNG，放进 `assets/`，供 HTML 用 `<img src="assets/figN.png">` 引用。

> **核心策略：整页高清渲染 → 按图区裁剪 → 逐张查看校验 → 不满意就重裁。**
> 不要用 `pdfimages` 抽嵌入图——复合图会碎成几十个片段、还常丢矢量标注；渲染整页再裁能保留完整图与标签。

## 工具

- `pdftoppm`（poppler，通常已装）：既能整页渲染，也能**自带裁剪参数**，无需 ImageMagick。
  - `-png -r <dpi>`：输出 PNG，200 DPI 下 letter 页 = 1700×2200 px（A4≈1654×2339）。
  - `-f N -l N`：只渲染第 N 页。
  - `-x -y -W -H`：在该 DPI 像素坐标下裁剪矩形（x,y=左上角，W,H=宽高）。
- 输出文件名带页码后缀，如 `assets/fig3-04.png`（-f 4 → 后缀 `-04`）。

## 标准流程

### 1. 先渲染整页，用于标定坐标

```bash
cd "<论文目录>"
mkdir -p assets
pdftoppm -png -r 200 "论文.pdf" assets/pg      # 生成 assets/pg-01.png … pg-NN.png
identify assets/pg-01.png 2>/dev/null || file assets/pg-01.png   # 确认尺寸(如1700x2200)
```

### 2. 用 Read 工具查看含图的整页，读出图区坐标

Read 一张 `assets/pg-XX.png`，工具会提示形如：
`[Image: original 1700x2200, displayed at 1545x2000. Multiply coordinates by 1.10 ...]`
把你在displayed图上目测的图区角点 **乘以该系数** 得到原图像素坐标。
经验：letter 双栏 CVPR/arXiv 论文，左栏 x≈150–830，右栏 x≈880–1560，跨栏图 x≈160–1690。

### 3. 按图区裁剪（一次可并列多条，互相独立）

```bash
P="论文.pdf"
# 跨栏系统图（页4顶部）：
pdftoppm -png -r 200 -f 4 -l 4 -x 160 -y 185 -W 1540 -H 405 "$P" assets/fig3
# 左栏小图（页6）：
pdftoppm -png -r 200 -f 6 -l 6 -x 155 -y 555 -W 665 -H 262 "$P" assets/fig4
# 右栏图（页7）：
pdftoppm -png -r 200 -f 7 -l 7 -x 885 -y 600 -W 700 -H 300 "$P" assets/fig6
```

### 4. 逐张 Read 查看裁剪结果，校验并微调（关键，别省）

对每张 `assets/figN-XX.png` 用 Read 查看：
- **裁多了**（含页眉/正文/相邻图/别的图注）→ 收紧 x/y/W/H 重裁。
- **裁少了**（子图被切、坐标轴数字/图例/标签被切）→ 放大 W/H 或上移 y 重裁。
- 复合图的**数值标签行**（如 "DROID-SLAM / Ours / Chamfer 0.xxx"）通常在子图正下方，容易漏——特意把 H 加大把它包进来。
- 定性对比图三联（A/B/Ours）常在页面中部，注意别把上一张图的图注也裁进来。

典型微调：图被截断且不确定标签在哪，就**先渲染该区域的窄条**定位：
```bash
pdftoppm -png -r 200 -f 14 -l 14 -x 150 -y 1260 -W 1430 -H 130 "$P" assets/probe   # 探测标签行 y 坐标
```

### 5. 重命名 + 清理

```bash
cd assets
for f in fig1-01 fig2-03 fig3-04 …; do n=$(echo "$f"|sed -E 's/fig([0-9]+)-.*/\1/'); mv -f "$f.png" "fig$n.png"; done
rm -f pg-*.png probe*.png          # 删掉整页渲染与探测图，只留 fig1.png…figN.png
```

## 常见坑

- **ImageMagick 未装很正常**：用 `pdftoppm` 的 `-x/-y/-W/-H` 就够，别去装 convert。
- **坐标是「该 DPI 下的像素」**：改 DPI 就得重算坐标（200 DPI 最顺手）。
- **letter=1700×2200@200dpi、A4≈1654×2339@200dpi**：先 `file`/`identify` 确认。
- **一次全渲染再逐图裁**比「每图单独 -f 渲染」省时；裁剪 pdftoppm 调用彼此独立，可在一条 bash 里并列。
- 裁好的图**必须逐张肉眼看过**——坐标估错时不看图，最后 HTML 里就是残图/错图。
- 图注**自己用中文重写并解读**（讲清这图在说明什么、关键结论），不要照抄英文 caption。
