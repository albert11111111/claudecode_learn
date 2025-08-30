import tushare as ts
ts.set_token('8f8a61f1e7298a55f588cf735abd0300b0b4cfffa5d5b7af30e85f0d')
pro = ts.pro_api()
df = pro.trade_cal(exchange='', start_date='20180901', end_date='20181001', fields='exchange,cal_date,is_open,pretrade_date', is_open='0')