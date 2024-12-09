class ProjectUtils {
  final String image;
  final String title;
  final String subtitle;
  final String? androidLink;
  final String? iosLlink;
  final String? webLink;

  ProjectUtils({
    required this.image,
    required this.title,
    required this.subtitle,
    this.androidLink,
    this.iosLlink,
    this.webLink
  });
}

// WORK PROJECTS
List<ProjectUtils> workProjectUtils = [
  ProjectUtils(
    image: 'assets/projects/w00.png',
    title: '8x8 voip',
    subtitle: 'some dummy subtitle',
    webLink: 'https://cpaas.8x8.com/ph/?utm_source=google&utm_medium=paid-search&utm_campaign=productowner-brand-ph-en&utm_adgroup=productowner-brand-ph-en&utm_content=710234136857&utm_term=8x8&gad_source=1&gclid=CjwKCAiA3Na5BhAZEiwAzrfagEAsb5gFP0r_xvZztAG92eEVTazVvtV-7_FOXsZVlP5c1AJDcRAiExoCF_kQAvD_BwE'
  ),
  ProjectUtils(
    image: 'assets/projects/w01.png',
    title: 'HomeCreditPH',
    subtitle: 'some dummy subtitle',
    webLink: 'https://play.google.com/store/apps/details?id=ph.homecredit.myhomecredit&hl=en&pli=1'
  ),
  ProjectUtils(
    image: 'assets/projects/w02.png',
    title: 'Monopond Fax Services',
    subtitle: 'some dummy subtitle',
    webLink: 'https://monopond.com/pricing/fax?location=global'
  ),
  ProjectUtils(
    image: 'assets/projects/w03.png',
    title: 'Rise PH',
    subtitle: 'PH internet provider',
    webLink: 'https://rise.ph'
  ),
];