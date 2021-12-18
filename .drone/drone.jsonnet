local configureAndDeploy() = {
    name: "configure-and-deploy",
    kind: "pipeline",
    type: "docker",
    triggers: {
        branch: ["master"],
        repo: ["hwittenborn/mailcow"]
    },
    volumes: [
        {
            name: "docker-socket",
            host: {path: "/var/run/docker.sock"}
        },

        {
            name: "docker-compose",
            host: {path: "/usr/bin/docker-compose"}
        },

        {
            name: "mailcow",
            host: {path: "/var/www/mailcow.hunterwittenborn.com"}
        }
    ],

    steps: [
        {
            name: "configure",
            image: "ubuntu:20.04",
            environment: {
                mailcow_db_user_password: {from_secret: "mailcow_db_user_password"},
                mailcow_db_root_password: {from_secret: "mailcow_db_root_password"}
            },
            commands: [
                "apt-get update",
                "apt-get install sed -y",

                "export MAILCOW_HOSTNAME=\"mailcow.$${hw_url}\"",
                "export MAILCOW_TZ=\"$(cat /etc/timezone)\"",
                "./generate_config.sh",

                "sed -i \"s|^DBPASS=.*|DBPASS=$${mailcow_db_user_password}|\" mailcow.conf",
                "sed -i \"s|^DBROOT=.*|DBROOT=$${mailcow_db_root_password}|\" mailcow.conf",
                "sed -i \"s|^HTTP_PORT=.*|HTTP_PORT=5070|\" mailcow.conf",
                "sed -i \"s|^HTTPS_PORT=.*|HTTPS_PORT=5071|\" mailcow.conf",
                "sed -Ei \"s;^(HTTP_BIND)=.*|^(HTTPS_BIND)=.*;\\1=127.0.0.1;\" mailcow.conf",
                "sed -i \"s|^ADDITIONAL_SAN=.*|ADDITIONAL_SAN=imap.$${hw_url},smtp.$${hw_url}|\" mailcow.conf"
            ]
        },

        {
            name: "deploy",
            image: "ubuntu:20.04",
            volumes: [
                {
                    name: "docker-socket",
                    path: "/var/run/docker.sock"
                },

                {
                    name: "docker-compose",
                    path: "/usr/bin/docker-compose"
                },

                {
                    name: "mailcow",
                    path: "/var/www/mailcow.hunterwittenborn.com"
                }
            ],
            commands: [
                "apt-get update",
                "apt-get install docker.io -y",
                "find '/var/www/mailcow.hunterwittenborn.com' -maxdepth 1 -not -path '/var/www/mailcow.hunterwittenborn.com' -not -path '/var/www/mailcow.hunterwittenborn.com/service.sh' -exec rm '{}' -rf \\;",
                "find ./ -maxdepth 1 -exec cp '{}' '/var/www/mailcow.hunterwittenborn.com/{}' -R \\;",
                "cd '/var/www/mailcow.hunterwittenborn.com'",
                "docker-compose down --remove-orphans",
                "docker-compose up -d"
            ]
        }
    ]
};

[configureAndDeploy()]
