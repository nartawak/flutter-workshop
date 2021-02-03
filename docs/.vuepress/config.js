const fs = require("fs");
const path = require("path");

function getSideBar(folder, title) {
  const extension = [".md"];

  const files = fs
    .readdirSync(path.join(`${__dirname}/../${folder}`))
    .filter(
      (item) =>
        item.toLowerCase() != "readme.md" &&
        fs.statSync(path.join(`${__dirname}/../${folder}`, item)).isFile() &&
        extension.includes(path.extname(item))
    );

  return [{ title: title, children: ["", ...files] }];
}

module.exports = {
  plugins: {
    sitemap: {
      hostname: "https://flutter.nartawak.dev",
    },
  },
  locales: {
    "/": {
      lang: "en-US",
      title: "Flutter Workshops",
    },
  },
  themeConfig: {
    editLinkText: "Edit cette page sur Github",
    lastUpdated: "Mis à jour le",
    repo: "nartawak/flutter-workshop",
    repoLabel: "Contribue !",
    docsRepo: "nartawak/flutter-workshop",
    docsDir: "docs",
    editLinks: true,
    algolia: {
      apiKey: "52f16fde1657a442a7341f738831ad23",
      indexName: "FLUTTER_WORKSHOP",
    },
    locales: {
      "/": {
        selectText: "Languages",
        label: "English",
        nav: [
          { text: "Home", link: "/" },
          { text: "Workshops", link: "/get_started/" },
        ],
        sidebar: [
          "/get_started/",
          {
            title: "Workshops",
            collapsable: false,
            path: "/workshops/",
            children: [
              {
                title: "Punk API",
                collapsable: true,
                path: "/workshops/01_punk_api/",
                children: [
                  "/workshops/01_punk_api/00_initial",
                  "/workshops/01_punk_api/01_layout",
                  "/workshops/01_punk_api/02_network",
                  "/workshops/01_punk_api/03_listview",
                  "/workshops/01_punk_api/04_theme_assets",
                  "/workshops/01_punk_api/05_navigation",
                  "/workshops/01_punk_api/06_detail",
                ],
              },
            ],
          },
        ],
      },
    },
  },
};
