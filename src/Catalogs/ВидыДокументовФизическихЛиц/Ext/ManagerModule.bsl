﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	ЗарплатаКадрыВызовСервера.ПодготовитьДанныеВыбораКлассификаторовСПорядкомРеквизитаДопУпорядочивания(ДанныеВыбора, Параметры, СтандартнаяОбработка, "Справочник.ВидыДокументовФизическихЛиц");
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли