// @license
package nanosome.fit {
	/**
	 * @author mh
	 */
	public function notifyParentAboutSizeChange( object: ILayoutable ): Boolean {
		if( object.parent is ILayout ) {
			return ILayout( object.parent ).registerSizeChangeOfChild( object );
		}
		else return true;
	}
}
