module.exports = {
  plugins: {
    sitemap: {
      hostname: "https://flutter-workshop.netlify.com"
    }
  },
  locales: {
    "/": {
      lang: "en-US", // this will be set as the lang attribute on <html>
      title: "Flutter Workshops"
    }
  },
  themeConfig: {
    editLinkText: "Edit cette page sur Github",
    lastUpdated: "Mis à jour le",
    repo: "nartawak/flutter-workshop",
    repoLabel: "Contribue !",
    docsRepo: "nartawak/flutter-workshop",
    docsDir: "docs",
    editLinks: true,
    locales: {
      "/": {
        selectText: "Languages",
        label: "English",
        nav: [
          { text: "Home", link: "/" },
          { text: "Workshops", link: "/workshops/" }
        ],
        sidebar: [
          "/workshops/",
          "/why.md",
          {
            title: "Step 1",
            collapsable: false,
            children: ["/workshops/step1/first"]
          }
        ]
      }
    }
  }
};
