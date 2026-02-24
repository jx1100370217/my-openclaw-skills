# 东方财富数据接口 (East Money API)

A股市场数据查询技能，基于东方财富/天天基金/新浪财经的公开API。

## 可用接口一览

### 1. 个股实时行情
```bash
curl -s 'https://push2.eastmoney.com/api/qt/stock/get?secid={secid}&fields=f57,f58,f43,f44,f45,f46,f47,f48,f60,f170,f171&ut=fa5fd1943c7b386f172d6893dbbd1d0c' \
  -H 'Referer: https://quote.eastmoney.com/' -H 'User-Agent: Mozilla/5.0'
```
- **secid格式**: `{market}.{code}` — 沪市 market=1，深市 market=0
  - 例: 上证指数 `1.000001`，石化机械 `0.000852`，新易盛 `0.300502`
- **返回字段**:
  - f57=代码, f58=名称, f43=现价(分), f44=最高(分), f45=最低(分), f46=开盘(分)
  - f47=成交量(手), f48=成交额, f60=昨收(分), f170=涨跌幅(百分比×100), f171=振幅
- ⚠️ **价格单位是分（×100），需要除以100转换为元**

### 2. 批量指数/个股行情
```bash
curl -s 'https://push2.eastmoney.com/api/qt/ulist.np/get?secids=1.000001,0.399001,0.399006&fields=f2,f3,f4,f12,f14&ut=fa5fd1943c7b386f172d6893dbbd1d0c' \
  -H 'Referer: https://quote.eastmoney.com/' -H 'User-Agent: Mozilla/5.0'
```
- 多个secid用逗号分隔
- f2=现价(分), f3=涨跌幅(×100), f4=涨跌额(分), f12=代码, f14=名称

### 3. K线历史数据
```bash
curl -s 'https://push2his.eastmoney.com/api/qt/stock/kline/get?secid={secid}&fields1=f1,f2,f3&fields2=f51,f52,f53,f54,f55,f56,f57&klt={klt}&fqt=1&end=20500101&lmt={lmt}&ut=fa5fd1943c7b386f172d6893dbbd1d0c' \
  -H 'Referer: https://quote.eastmoney.com/' -H 'User-Agent: Mozilla/5.0'
```
- **klt**: 101=日K, 102=周K, 103=月K, 1=1分钟, 5=5分钟, 15=15分钟, 30=30分钟, 60=60分钟
- **lmt**: 返回条数
- **fqt**: 1=前复权, 2=后复权, 0=不复权
- **klines格式**: "日期,开盘,收盘,最高,最低,成交量,成交额,振幅,涨跌幅,涨跌额,换手率"

### 4. 分时成交明细
```bash
curl -s 'https://push2.eastmoney.com/api/qt/stock/details/get?secid={secid}&fields1=f1,f2,f3,f4&fields2=f51,f52,f53,f54,f55&ut=fa5fd1943c7b386f172d6893dbbd1d0c' \
  -H 'Referer: https://quote.eastmoney.com/' -H 'User-Agent: Mozilla/5.0'
```

### 5. 大盘资金流向（分时）
```bash
curl -s 'https://push2.eastmoney.com/api/qt/stock/fflow/kline/get?secid=1.000001&fields1=f1,f2,f3,f7&fields2=f51,f52,f53,f54,f55,f56,f57,f58,f59,f60,f61,f62,f63,f64,f65&klt=1&lmt=0&ut=fa5fd1943c7b386f172d6893dbbd1d0c' \
  -H 'Referer: https://data.eastmoney.com/' -H 'User-Agent: Mozilla/5.0'
```
- klines格式: "时间,主力净流入,小单净流入,中单净流入,大单净流入,超大单净流入"

### 6. 基金实时净值估算（天天基金）
```bash
curl -s 'https://fundgz.1234567.com.cn/js/{fundcode}.js' \
  -H 'Referer: https://fund.eastmoney.com/'
```
- 返回JSONP: `jsonpgz({...})`
- 字段: fundcode, name, dwjz=最新净值, gsz=估算净值, gszzl=估算涨跌幅%, gztime=估算时间

### 7. 基金净值历史（天天基金）
```bash
curl -s 'https://api.fund.eastmoney.com/f10/lsjz?fundCode={code}&pageIndex=1&pageSize=20' \
  -H 'Referer: https://fund.eastmoney.com/' -H 'User-Agent: Mozilla/5.0'
```
- LSJZList[]: FSRQ=日期, DWJZ=单位净值, LJJZ=累计净值, JZZZL=涨跌幅%

### 8. 基金持仓查询（天天基金）
```bash
curl -s 'https://fundf10.eastmoney.com/FundArchivesDatas.aspx?type=jjcc&code={fundcode}&topline=10' \
  -H 'Referer: https://fund.eastmoney.com/' -H 'User-Agent: Mozilla/5.0'
```
- 返回HTML格式，需解析

### 9. 基金搜索
```bash
curl -s 'https://fundsuggest.eastmoney.com/FundSearch/api/FundSearchAPI.ashx?m=1&key={keyword}'
```

### 10. 板块排行榜（行业/概念）— 涨幅、资金流向等
```bash
# 行业板块涨幅排行 TOP5
curl -s 'https://push2.eastmoney.com/api/qt/clist/get?cb=j&pn=1&pz=5&po=1&np=1&ut=fa5fd1943c7b386f172d6893dbbd1d0c&fltt=2&invt=2&fid=f3&fs=m:90+t:2+f:!50&fields=f12,f14,f2,f3,f62,f184' \
  -H 'Referer: https://data.eastmoney.com/' -H 'User-Agent: Mozilla/5.0'

# 行业板块主力资金净流入排行（fid改为f62）
curl -s 'https://push2.eastmoney.com/api/qt/clist/get?cb=j&pn=1&pz=5&po=1&np=1&ut=fa5fd1943c7b386f172d6893dbbd1d0c&fltt=2&invt=2&fid=f62&fs=m:90+t:2+f:!50&fields=f12,f14,f2,f3,f62,f184' \
  -H 'Referer: https://data.eastmoney.com/' -H 'User-Agent: Mozilla/5.0'

# 概念板块（fs 改为 m:90+t:3+f:!50）
curl -s 'https://push2.eastmoney.com/api/qt/clist/get?cb=j&pn=1&pz=5&po=1&np=1&ut=fa5fd1943c7b386f172d6893dbbd1d0c&fltt=2&invt=2&fid=f62&fs=m:90+t:3+f:!50&fields=f12,f14,f2,f3,f62,f184' \
  -H 'Referer: https://data.eastmoney.com/' -H 'User-Agent: Mozilla/5.0'
```
- ⚠️ **关键**: 必须带 `pn=1` 参数，否则返回 rc:102！
- **fs参数**: `m:90+t:2` = 行业板块(含大类+细分共498个), `m:90+t:3` = 概念板块, `m:90+t:1` = 地域板块
- **fid排序**: f3=涨跌幅, f62=主力净流入, f184=主力净占比
- ⚠️ **行业板块包含大类和细分**: t:2 返回的498个板块混合了一级大类（电子、有色金属、通信等~30个）和细分行业（通信设备、电网设备、元件等~460个）。东方财富APP默认显示的是**细分行业**排名。如需匹配APP显示，应过滤掉一级大类板块。
- **一级大类板块参考**（约30个，资金金额通常偏大因为包含了子行业）：电子、有色金属、通信、基础化工、建筑装饰、机械设备、电力设备、汽车、计算机、医药生物、食品饮料、银行、非银金融、房地产、公用事业、交通运输、轻工制造、纺织服饰、商贸零售、社会服务、传媒、综合、农林牧渔、钢铁、煤炭、石油石化、环保、美容护理、国防军工、建筑材料
- **po**: 1=降序, 0=升序
- **返回字段**: f12=板块代码, f14=板块名称, f2=最新点位, f3=涨跌幅%, f62=主力净流入(元), f184=主力净占比%
- 返回格式为JSONP: `j({...})`，需去掉 `j(` 和 `);`

### 11. 龙虎榜（datacenter-web）
```bash
# 查某一天龙虎榜（盘后数据，当天盘中不可用）
curl -s "https://datacenter-web.eastmoney.com/api/data/v1/get?reportName=RPT_DAILYBILLBOARD_DETAILSNEW&columns=SECURITY_CODE,SECURITY_NAME_ABBR,CHANGE_RATE,BILLBOARD_NET_AMT,BILLBOARD_BUY_AMT,BILLBOARD_SELL_AMT,DEAL_AMOUNT_RATIO,EXPLANATION,TRADE_DATE&pageNumber=1&pageSize=10&sortColumns=BILLBOARD_NET_AMT&sortTypes=-1&source=WEB&client=WEB&filter=%28TRADE_DATE%3D%27{YYYY-MM-DD}%27%29" \
  -H 'User-Agent: Mozilla/5.0'

# 不带 filter 则返回历史全部（按净买入排序）
```
- **字段**: SECURITY_CODE=代码, SECURITY_NAME_ABBR=名称, CHANGE_RATE=涨跌幅%, BILLBOARD_NET_AMT=净买入额(元), BILLBOARD_BUY_AMT=买入额, BILLBOARD_SELL_AMT=卖出额, DEAL_AMOUNT_RATIO=成交占比%, EXPLANATION=上榜原因
- ⚠️ **龙虎榜是盘后数据**，一般收盘后1-2小时才更新，盘中查不到当天数据
- filter中日期用URL编码: `%28TRADE_DATE%3D%27YYYY-MM-DD%27%29`

### 12. 板块资金流向（新浪财经 - 备用）
```bash
# 概念板块资金流入排名
curl -s 'https://vip.stock.finance.sina.com.cn/quotes_service/api/json_v2.php/MoneyFlow.ssl_bkzj_bk?page=1&num=5&sort=netamount&asc=0&fenlei=1' \
  -H 'Referer: https://finance.sina.com.cn/'
# fenlei: 0=行业, 1=概念, 2=地域

# 个股资金流入排名
curl -s 'https://vip.stock.finance.sina.com.cn/quotes_service/api/json_v2.php/MoneyFlow.ssl_bkzj_zjlrqs?page=1&num=5&sort=netamount&asc=0&bankuai=&shession=qr' \
  -H 'Referer: https://finance.sina.com.cn/'
```
- 字段: name=名称, netamount=主力净流入, ratioamount=净占比, inamount=流入, outamount=流出
- ts_symbol=领涨股代码, ts_name=领涨股名称, ts_changeratio=领涨股涨跌幅

### 11. 雪球实时行情（备用）
```bash
curl -s 'https://stock.xueqiu.com/v5/stock/realtime/quotec.json?symbol={symbols}' \
  -H 'Cookie: xq_a_token=test'
```
- symbols格式: SH600183,SZ300308（多个逗号分隔）
- 返回: current=现价, percent=涨跌幅%, chg=涨跌额, high/low/open/last_close 等

## secid 速查

| 市场 | market | 示例 |
|------|--------|------|
| 沪市主板 | 1 | 1.600183（生益科技）|
| 深市主板/中小板 | 0 | 0.000852（石化机械）|
| 创业板 | 0 | 0.300502（新易盛）|
| 科创板 | 1 | 1.688008（澜起科技）|
| 上证指数 | 1 | 1.000001 |
| 深证成指 | 0 | 0.399001 |
| 创业板指 | 0 | 0.399006 |

## 注意事项

1. **东方财富push2 clist接口**: 必须带 `pn=1` 参数！否则返回 rc:102
2. **板块资金流向**: 优先用东方财富 clist 接口（带pn=1），新浪财经作为备用
3. **ut参数**: 使用 `fa5fd1943c7b386f172d6893dbbd1d0c` 或 `b2884a393a59ad64002292a3e90d46a5`
4. **价格精度**: push2接口返回的价格通常是分为单位（×100），注意转换
5. **Referer必须**: 大部分接口需要带正确的 Referer header
6. **雪球接口**: 不需要真实token，但需要Cookie header
7. **交易时间**: A股交易时间 9:30-11:30, 13:00-15:00（北京时间）
