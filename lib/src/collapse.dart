part of bootjack;

class Collapse extends Base {
  
  static const _name = 'collapse';
  
  /** Construct a collapse component and wire it to [element].
   * 
   * + If [toggle] is true, Toggles the collapsible element on invocation. Default: true.
   * + 
   * [parent] determines if selector then all collapsible elements under the specified parent 
   * will be closed when this collapsible item is shown. 
   * (similar to traditional accordion behavior - 
   * this dependent on the accordion-group class)
   * 
   */
  Collapse(Element element, {bool? toggle, String? parent}) :
  this._toggle  = _data(toggle, element, 'toggle', true),
  super(element, _name) {
    if (parent == null)
      parent = element.attributes["data-parent"];
    if (parent != null)
      _$parent = $(parent);
    
    if (_toggle)
      this.toggle();
  }
  
  /** Retrieve the wired Collapse object from an element. If there is no wired
   * Collapse object, a new one will be created.
   * 
   * + [create] - If provided, it will be used for Collapse creation. Otherwise 
   * the default constructor with no optional parameter value is used.
   */
  static Collapse wire(Element element, [Collapse create()?]) =>
      p.wire(element, _name, create ?? (() => Collapse(element)));
  
  
  final bool _toggle;
  ElementQuery? _$parent;
  
  bool get transitioning => _transitioning;
  bool _transitioning = false;
  
  bool get horizontal => _horizontal ??= element.classes.contains('width');
  bool? _horizontal;
  
  void show() {
    if (transitioning || element.classes.contains('in'))
      return;

    final e = QueryEvent('show.bs.collapse');
    $element.triggerEvent(e);
    
    if (e.defaultPrevented)
      return;

    final $parent = _$parent;
    if ($parent != null) {
      final panels = $parent.children('.panel');
      if (panels.isNotEmpty) {
        for (final panel in panels) {
          for (final elem in $(panel).children('.in, .collapsing')) {
            final active = $(elem).data.get(_name) as Collapse?;
            if (active?.transitioning ?? false)
              return;
            
            Collapse.wire(elem).hide();
            $(elem).data.set(_name, null);
          }
          
        }
      }
    }
    
    
    element.classes
    ..remove('collapse')
    ..add('collapsing');
    _size = '0';
    
    _transitioning = true;
    
    final complete = (QueryEvent? e) {
      element.classes
      ..remove('collapsing')
      ..add('in');
      _size = 'auto';
      _transitioning = false;
      $element.trigger('shown.bs.collapse');
    };
    
    
    if (!Transition.isUsed) {
      complete(null);
    } else {
      $element.one(Transition.end, complete);
      _size = '${horizontal ? element.scrollWidth : element.scrollHeight}px';
    }
  }
  
  void hide() {
    if (transitioning || !element.classes.contains('in'))
      return;
    
    
    final QueryEvent e = new QueryEvent('hide.bs.collapse');
    $element.triggerEvent(e);
    
    if (e.defaultPrevented)
      return;

    final size = horizontal ? $element.width : $element.height;
    _size = "${size}px";
    element.offsetHeight;
    
    element.classes
    ..add('collapsing')
    ..remove('collapse')
    ..remove('in');
    
    _transitioning = true;
    
    final complete = (QueryEvent? e) {
      _transitioning = false;
      $element.trigger('hidden.bs.collapse');
      element.classes
      ..remove('collapsing')
      ..add('collapse');
    };
    
    if (!Transition.isUsed) {
      complete(null);
    } else {
      _size = '0';
      $element.one(Transition.end, complete);
    }
    
  }
  
  void set _size(String size) {
    if (horizontal)
      element.style.width = size;
    else
      element.style.height = size;
  }
  
  void toggle() {
    if (element.classes.contains('in'))
      hide();
    else
      show();
  }
  
  static bool _registered = false;
  
  /** Register to use Collapse component.
   */
  static void use() {
    if (_registered) return;
    _registered = true;
    
    $document().on('click.bs.collapse.data-api', (QueryEvent e) {
      Element elem = e.currentTarget as Element;

      var targetStr = elem.attributes['data-target'];
      if (targetStr == null) {
        e.preventDefault();
        final href = elem.attributes['href'];
        if (href != null)
          targetStr = href.replaceAll(RegExp(r'.*(?=#[^\s]+$)'), ''); //strip for ie7
      }

      final $target = $(targetStr),
        target = $target[0],
        collapse = $target.data.get(_name) as Collapse?,
        parent = elem.attributes['data-parent'],
        $parent = $(parent);
      
      if (collapse == null || !collapse.transitioning) {
        if (parent != null) {
          final collapses = $parent.find(
              '[data-toggle=collapse][data-parent="$parent"]');
          for (final e in collapses) {
            if (e == elem) continue;
            e.classes.add('collapsed');
            
          }
        }
        elem.classes.toggle('collapsed', target.classes.contains('in'));
      }
      
      if (collapse != null) {
        collapse.toggle();
      } else {
        final parentAtr = elem.attributes['data-parent'],
          toggleAtr = elem.attributes['data-toggle'];
        
        Collapse(target, toggle: toggleAtr != null ? true: null, parent: parentAtr);
      }
      
    }, selector: '[data-toggle=collapse]');
    
  }
  
}