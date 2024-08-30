// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import AddressSearchController from "./address_search_controller"
application.register("address-search", AddressSearchController)

import ModalController from "./modal_controller"
application.register("modal", ModalController)

import MapController from "./map_controller"
application.register("map", MapController)

import MaskController from "./mask_controller"
application.register("mask", MaskController)

import HelloController from "./hello_controller"
application.register("hello", HelloController)
