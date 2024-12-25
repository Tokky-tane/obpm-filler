# OBPM 自動入力ツール

## initialization

```sh
bash install.sh
```


## usage

`OBPM_COMPANY_ID` は `https://obpm.jp/XXXXX/` の `XXXXX` に該当する部分

```sh
OBPM_ID=XXXXX OBPM_PASSWORD=XXXXX OBPM_COMPANY_ID=XXXXX bundle exec ruby main.rb man_hours.yml
```
