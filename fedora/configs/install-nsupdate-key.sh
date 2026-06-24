#!/bin/sh
#
# Install NSUpdateKey
#
cat <<EOF > /var/tmp/nsupdate.key
key "acme-update-key" {
   algorithm hmac-sha512;
   secret "bKH+G04LzyI6jnV1gPr0uRAGBIOrQw5ZSeaFJDdlN8/wnrgXHF6xrfWayn20V1Ei5wOGQ2BNbZ+YBDEtAkNTSQ==";
};
EOF

