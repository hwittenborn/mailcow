local configureAndDeploy() = {
    name: "configure-and-deploy",
    kind: "pipeline",
    type: "exec",
    triggers: {
        branch: ["master"],
        repo: ["hwittenborn/mailcow"]
    },
    node: {server: "homelab"},
    steps: [
        {
            name: "configure",
            environment: {
                mailcow_db_user_password: {from_secret: "mailcow_db_user_password"},
                mailcow_db_root_password: {from_secret: "mailcow_db_root_password"}
            },
            commands: [".drone/scripts/configure.sh"]
        },

        {
            name: "deploy",
            commands: [".drone/scripts/deploy.sh"]
        }
    ]
};

[configureAndDeploy()]
