////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2009 Adobe Systems Incorporated
//  All Rights Reserved.
//
//  NOTICE: Adobe permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package spark.accessibility
{
    
import flash.accessibility.Accessibility;
import flash.events.Event;
import flash.events.FocusEvent;

import mx.accessibility.AccConst;
import mx.core.UIComponent;
import mx.core.mx_internal;

import spark.components.ComboBox;
import spark.components.TextInput;
import spark.events.IndexChangeEvent;
import spark.events.SkinPartEvent;

use namespace mx_internal;

/**
 *  ComboBoxAccImpl is a subclass of AccessibilityImplementation
 *  which implements accessibility for the ComboBox class.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public class ComboBoxAccImpl extends DropDownListBaseAccImpl
{
    include "../core/Version.as";
    
    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Enables accessibility in the ComboBox class.
     * 
     *  <p>This method is called by application startup code
     *  that is autogenerated by the MXML compiler.
     *  Afterwards, when instances of ComboBox are initialized,
     *  their <code>accessibilityImplementation</code> property
     *  will be set to an instance of this class.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public static function enableAccessibility():void
    {
        ComboBox.createAccessibilityImplementation =
            createAccessibilityImplementation;
    }
    
    /**
     *  @private
     *  Creates a ComboBox's AccessibilityImplementation object.
     *  This method is called from UIComponent's
     *  initializeAccessibility() method.
     */
    mx_internal static function createAccessibilityImplementation(
        component:UIComponent):void
    {
        component.accessibilityImplementation =
            new ComboBoxAccImpl(component);
    }
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Constructor.
     *
     *  @param master The UIComponent instance that this AccImpl instance
     *  is making accessible.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function ComboBoxAccImpl(master:UIComponent)
    {
        super(master);
        
        // ComboBox has a TextInput as a skin part,
        // and we need to listen to some of its events.
        // It may or may not be present when this constructor is called.
        // If it comes or goes later, we are notified via
        // "partAdded" and "partRemoved" events.
        var textInput:TextInput = ComboBox(master).textInput;
        if (textInput)
            textInput.addEventListener(Event.CHANGE, textInputChangeHandler);
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden properties: AccImpl
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  eventsToHandle
    //----------------------------------
    
    /**
     *  @private
     *  Array of events that we should listen for from the master component.
     */
    override protected function get eventsToHandle():Array
    {
        return super.eventsToHandle.concat([ FocusEvent.FOCUS_IN,
                                             SkinPartEvent.PART_ADDED,
                                             SkinPartEvent.PART_REMOVED ]);
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods: AccessibilityImplementation
    //
    //--------------------------------------------------------------------------
    /**
     *  @private
     *  Returns the name of the component.
     *
     *  @param childID uint.
     *
     *  @return Name of the component.
     *
     *  @tiptext Returns the name of the component
     */
    override public function get_accName(childID:uint):String
    {
        if (childID <= 1)
            return super.get_accName(0);
        else
            return super.get_accName(childID - 1);
    }
    
    
    /**
     *  @private
     *  Gets the role for the component.
     *
     *  @param childID children of the component
     */
    override public function get_accRole(childID:uint):uint
    {
        if (childID == 1)
            return AccConst.ROLE_SYSTEM_TEXT;
        else if (childID == 0)
            return super.get_accRole(0);
        else 
            return super.get_accRole(childID - 1);
    }
    
    /**
     *  @private
     *  IAccessible method for returning the state of the ComboBox.
     *  States are predefined for all the components in MSAA.
     *  Values are assigned to each state.
     *
     *  @param childID uint
     *
     *  @return State uint
     */
    override public function get_accState(childID:uint):uint
    {
        if (childID <= 1)
            return  super.get_accState(0);
        else {
            return super.get_accState(ComboBox(master).isDropDownOpen ? childID -1 : 0);
        }
    }
    
    /**
     *  @private
     *  IAccessible method for returning the Default Action.
     *
     *  @param childID uint
     *
     *  @return DefaultAction String
     */
    override public function get_accDefaultAction(childID:uint):String
    {
        if (childID <= 1)
            return null;
        
        return super.get_accDefaultAction(childID - 1);
    }
    
    /**
     *  @private
     *  IAccessible method for executing the Default Action.
     *
     *  @param childID uint
     */
    override public function accDoDefaultAction(childID:uint):void
    {
        if (childID > 1)
            super.accDoDefaultAction(childID -1);
    }
    
    /**
     *  @private
     *  Method to return an array of childIDs.
     *
     *  @return Array
     */
    override public function getChildIDArray():Array
    {
        var childIDArray:Array = super.getChildIDArray();
        childIDArray[childIDArray.length] = childIDArray.length;
        return childIDArray;
    }
    
    /**
     *  @private
     *  IAccessible method for returning the childFocus of the List.
     *
     *  @param childID uint
     *
     *  @return focused childID.
     */
    override public function get_accFocus():uint
    {
        var index:uint = super.get_accFocus();
        return index > 0 ? index + 1 : 0;
    }
    
    /**
     *  @private
     *  IAccessible method for returning the bounding box of the ListItem.
     *
     *  @param childID uint
     *
     *  @return Location Object
     */
    override public function accLocation(childID:uint):*
    {
        if (childID == 0)
            return super.accLocation(0);
        else if (childID == 1)
            return ComboBox(master).textInput;
        else
            return super.accLocation(childID - 1);
    }
    
    /**
     *  @private
     *  IAccessible method for selecting an item.
     *
     *  @param childID uint
     */
    override public function accSelect(selFlag:uint, childID:uint):void
    {
        if (childID > 1 )
            super.accSelect(selFlag, childID - 1)
    }
    
    /**
     *  @private
     *  IAccessible method for returning the value of the ComboBox
     *  (which would be the text of the item selected 
     *  or the text entered in textInput).
     *  @param childID uint
     *
     *  @return Value String
     */
    override public function get_accValue(childID:uint):String
    {
        var comboBox:ComboBox = ComboBox(master);
        if (childID <= 1)
            return comboBox.selectedIndex == -1 ?
                comboBox.textInput.text :comboBox.selectedItem;
        return null;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods: AccImpl
    //
    //--------------------------------------------------------------------------
    
    
    //--------------------------------------------------------------------------
    //
    //  Overridden event handlers: AccImpl
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     *  Override the generic event handler.
     *  All AccImpl must implement this
     *  to listen for events from its master component.
     */
    override protected function eventHandler(event:Event):void
    {
        var textInput:TextInput;
        if (event is IndexChangeEvent)
        {
            var tweaked_event:Event = event.clone();
            IndexChangeEvent(tweaked_event).oldIndex += 1;
            IndexChangeEvent(tweaked_event).newIndex += 1;
            super.eventHandler(tweaked_event);
        } 
                
        switch (event.type)
        {
            case "open":
            {
                Accessibility.sendEvent(master, 0, AccConst.EVENT_OBJECT_STATECHANGE);
                break;
            }

            case "focusIn":
            {
                Accessibility.sendEvent(master, 0, AccConst.EVENT_OBJECT_FOCUS);
                break;
            }

            case "caretChange":
            {
                var index:uint = IndexChangeEvent(event).newIndex;
                var childID:uint = index + 2;
                if (!ComboBox(master).isDropDownOpen) { 
                    Accessibility.sendEvent(master, 0,
                        AccConst.EVENT_OBJECT_VALUECHANGE);
                    Accessibility.sendEvent(master, 1,
                        AccConst.EVENT_OBJECT_VALUECHANGE);
                    
                }
                Accessibility.sendEvent(master, childID,
                    AccConst.EVENT_OBJECT_FOCUS);   
                
                break;
            }
                
            case SkinPartEvent.PART_ADDED:
            {
                textInput = ComboBox(master).textInput;
                if (SkinPartEvent(event).instance == textInput)
                {
                    textInput.addEventListener(Event.CHANGE,
                                               textInputChangeHandler);
                }
                break;
            }
                
            case SkinPartEvent.PART_REMOVED:
            {
                textInput = ComboBox(master).textInput;
                if (SkinPartEvent(event).instance == textInput)
                {
                    textInput.removeEventListener(Event.CHANGE,
                                                  textInputChangeHandler);
                }
                break;
            }
                
            default:
            {
                super.eventHandler(event);
            }
        }
    }
    
    /**
     *  @private
     */
    private function textInputChangeHandler(event:Event):void
    {
        Accessibility.sendEvent(master, 0, AccConst.EVENT_OBJECT_VALUECHANGE);
    }
}
    
    
}

