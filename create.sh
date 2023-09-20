#1. イメージのビルド
docker build  ./ -t espdev --no-cache 

#2. イメージを公開用にtag付け
docker tag espdev:latest unvsacrs/esp32-rust

#3. イメージをpush
docker push unvsacrs/esp32-rust
