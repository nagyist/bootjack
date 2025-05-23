part of bootjack;

// TODO
// 4. DQuery load()

/** A Modal box component.
 */
class Modal extends Base {
  
  static const _name = 'modal';
  
  /**
   * 
   */
  final String backdrop; // false, true, static: should use enum when ready
  
  /** Return true if the Modal component listens to escape key for closing.
   */
  final bool keyboard;
  
  /** Construct a Modal object and wire it to [element].
   */
  Modal(Element element, {String backdrop = 'true', bool keyboard = true, String? remote}) :
  this.backdrop = backdrop,
  this.keyboard = keyboard,
  super(element, _name) {
  }
  
  /** Retrieve the wired Modal object from an element. If there is no wired
   * Modal object, a new one will be created.
   * 
   * + [create] - If provided, it will be used for Modal creation. Otherwise 
   * the default constructor with no optional parameter value is used.
   */
  static Modal? wire(Element element, [Modal? create()?]) =>
      p.wire(element, _name, create ?? (() => Modal(element)));
  
  /** Toggle the visibility state of the Modal.
   */
  toggle() => _shown ? hide() : show();
  
  /** True if the Modal is shown.
   */
  bool get isShown => _shown;
  bool _shown = false;
  
  /** Show the Modal.
   */
  show() {
    
    final e = QueryEvent('show.bs.modal');
    $element.triggerEvent(e);
    
    if (_shown || e.defaultPrevented)
      return;
    _shown = true;
    
    if (keyboard) {
      $document().on('keyup.dismiss.modal', (QueryEvent e) {
        if ((e.originalEvent as KeyboardEvent).keyCode == 27)
          hide();
      });
    }
    
    _backdrop(() {
      
      final transition = Transition.isUsed && element.classList.contains('fade');
      
      if (element.parentElement == null)
        document.body?.append(element);
      
      $element.show();
      
      if (transition) $element.reflow();
      
      element.classList.add('in');
      element.setAttribute('aria-hidden', 'false');
      
      _enforceFocus();
      
      if (transition) {
        $element.one(Transition.end, (QueryEvent e) {
          $element.trigger('focus');
          $element.trigger('shown.bs.modal');
        });
        
      } else {
        $element.trigger('focus');
        $element.trigger('shown.bs.modal');
        
      }

      $element.on('click.modal.backdrop', (QueryEvent e){
        if($element[0] == e.target && backdrop != 'static'){
          hide();
        }
      });

      $element.on('click.dismiss.modal', (QueryEvent e) => hide(), selector: '[data-dismiss="modal"]');
    });
    
  }
  
  /** Hide the Modal.
   */
  hide() {
    
    final e = QueryEvent('hide.bs.modal');
    $element.triggerEvent(e);
    
    if (!_shown || e.defaultPrevented)
      return;

    _shown = false;
    
    $element.off('keyup.dismiss.modal');
    $element.off('click.modal.backdrop');
    $element.off('click.dismiss.modal');

    $document().off('focusin.modal');
    
    element.classList.remove('in');
    element.setAttribute('aria-hidden', 'true');
    
    if (Transition.isUsed && element.classList.contains('fade'))
      _hideWithTransition();
    else
      _hideModal();
  }
  
  void _enforceFocus() {
    $document().on('focusin.modal', (QueryEvent e) {
      final tar = e.target;
      if (!e.propagationStopped && element != tar &&
          (tar is! Node || tar.parentElement != element))
        $element.triggerEvent(QueryEvent('focus')..stopPropagation());
    });
  }
  
  void _hideWithTransition() {
    var canceled = false;
    Timer(const Duration(milliseconds: 500), () {
      if (!canceled) {
        $element.off(Transition.end);
        _hideModal();
      }
    });
    $element.one(Transition.end, (QueryEvent e) {
      canceled = true;
      _hideModal();
    });
  }
  
  void _hideModal() {
    $element.hide();
    _backdrop(() {
      _removeBackdrop();
      $element.trigger('hidden.bs.modal');
    });
  }
  
  Element? _backdropElem;
  
  void _removeBackdrop() {
    _backdropElem?.remove();
    _backdropElem = null;
  }
  
  void _backdrop([void callback()?]) {
    
    final fade = element.classList.contains('fade'),
      animate = Transition.isUsed && fade;
    var transit = false;
    
    var backdropElem = _backdropElem;
    if (_shown && backdrop != 'false') {
      
      backdropElem = _backdropElem = HTMLDivElement();
      backdropElem.classList.add('modal-backdrop');
      if (fade)
        backdropElem.classList.add('fade');
      document.body?.append(backdropElem);

      final $_backdropElem = $(_backdropElem);
      
      if (animate) $_backdropElem.reflow();
      
      backdropElem.classList.add('in');
      transit = true;
      
    } else if (!_shown && backdropElem != null) {
      backdropElem.classList.remove('in');
      transit = true;
    }
    
    if (callback != null) {
      if (animate && transit) {
        $(_backdropElem).one(Transition.end, (QueryEvent e) => callback());
      } else
        callback();
    }
  }
  
  // Data API //
  static bool _registered = false;
  
  /** Register to use Modal component.
   */
  static void use() {
    if (_registered) return;
    _registered = true;
    
    $document().on('click.modal.data-api', (QueryEvent e) {
      if (!e.target.isA<Element>())
        return;

      final elem = e.currentTarget as Element;
      //final String href = elem.attributes['href'];
      final $target = $(p.getDataTarget(elem));
      
      e.preventDefault();
      
      if ($target.isEmpty)
        return;
      
      // , option = $target.data('modal') ? 'toggle' : $.extend({ remote:!/#/.test(href) && href }, $target.data(), $this.data())
      Modal.wire($target.first, () => Modal($target.first))!.toggle(); // TODO: other options
      
      $target.one('hide', (QueryEvent e) => $(elem).trigger('focus'));
      
    }, selector: '[data-toggle="modal"]');
  }
  
}
