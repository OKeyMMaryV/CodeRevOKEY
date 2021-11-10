﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МетаданныеОбъекта = Метаданные.РегистрыСведений.бит_му_ПараметрыКлассовВНА;
	
	// Вызов механизма защиты
	

	бит_РаботаСДиалогамиСервер.ФормаСпискаРегистраПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтотОбъект);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если бит_му_ВНА.ЕстьОбъектыКласса(ТекущиеДанные.Класс,ТекущиеДанные.Организация)  Тогда
		
		Если ЗначениеЗаполнено(ТекущиеДанные.Организация) Тогда
			НачалоСообщения= НСтр("ru='Для организации ""%1%"" в '");
		Иначе
			НачалоСообщения= НСтр("ru='В '");
		КонецЕсли;
						 
		ОкончаниеСообщения = НСтр("ru='системе зарегистрированы объекты класса ""%2%"". Удаление запрещено!'");
		ТекстСообщения = НачалоСообщения + ОкончаниеСообщения;
		
		ТекстСообщения = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(ТекстСообщения, ТекущиеДанные.Организация, ТекущиеДанные.Класс);
		бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения,,,Отказ);
		
	 КонецЕсли;
	
КонецПроцедуры // СписокПередУдалением()
 
#КонецОбласти
