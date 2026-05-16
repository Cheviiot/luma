FROM alt:p11

# Устанавливаем stplr, сертификаты и зависимости для сборки
RUN apt-get update -qq && \
    apt-get install -y -qq stplr rpm-build ca-certificates ca-trust \
    meson python3 blueprint-compiler libgtk4-devel libadwaita-devel \
    gettext desktop-file-utils libappstream-glib glib2-devel \
    libwebkit2gtk4.1 libayatana-appindicator3-1 2>/dev/null && \
    update-ca-trust

WORKDIR /repo
COPY . /repo/

RUN chmod +x .github/test/test-packages.sh

ENTRYPOINT [".github/test/test-packages.sh"]
