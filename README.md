### Creating-a-new-image-for-HA-server-monitor-with-a-Dockerfile
> [name=Mr. Akashic] [time=Tue, Aug 24, 2021]

+ image name
  + akashic0616/ha-server-monitor:latest

+ 說明
  + HA server monitor image需搭配homeassistant/armv7-hassio-supervisor image一起使用，如附檔docker-compose.yml。
  
+ 功能
  + while loop 每五秒偵測一次樹莓派IP是否改變。
  + 若樹莓派IP改變了，且原本的IP無法連線(同時接網路線跟連Wi-Fi的情況兩個IP都有效)，自動修改Home Assistant的File editor的bt2mqtt_config的url欄位。
  + 修改後自動重新啟動Home Assistant。
