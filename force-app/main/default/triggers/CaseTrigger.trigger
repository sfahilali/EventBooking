/**
 * Created by ahilali on 14/12/2021.
 */

trigger CaseTrigger on Case (before insert, before update) {
    new CaseTriggerHandler().run();
}