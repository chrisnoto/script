docker run -p 9000:9000 --name minio1 \
    -e "MINIO_ACCESS_KEY=foxobjectstorage" \
    -e "MINIO_SECRET_KEY=foxobjectstorageminiominio" \
    -v /data:/data \
    minio/minio server /data

