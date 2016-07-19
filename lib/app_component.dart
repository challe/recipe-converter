import 'dart:html';

import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

import 'package:converter/services/recipe_service.dart';
import 'components/search/search.dart';
import 'components/about/about.dart';
import 'components/bookmarklet/bookmarklet.dart';

@Component(
    selector: 'my-app',
    templateUrl: 'app_component.html',
    providers: const [RecipeService],
    directives: const [ROUTER_DIRECTIVES])
@RouteConfig(const [
  const Route(
      path: '/search',
      name: 'Search',
      component: SearchComponent,
      useAsDefault: true),
  const Route(
      path: '/search:url', name: 'SearchURL', component: SearchComponent),
  const Route(path: '/about', name: 'About', component: AboutComponent),
  const Route(
      path: '/bookmarklet',
      name: 'Bookmarklet',
      component: BookmarkletComponent)
])
class AppComponent implements OnInit {
  final Router _router;
  AppComponent(this._router);
  String header;

  ngOnInit() {
    //String url = _routeParams.get("url");
    //window.console.info(url);

    //_router.navigate(["/Search"]);
  }
}
