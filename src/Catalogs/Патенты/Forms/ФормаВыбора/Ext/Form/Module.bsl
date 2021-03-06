
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если Параметры.Отбор.Свойство("Владелец") Тогда
		
		Организация = ОбщегоНазначенияБПВызовСервера.УстановитьОтборПоОсновнойОрганизации(ЭтотОбъект,,
			"Владелец", Параметры.Отбор.Владелец);
		Параметры.Отбор.Удалить("Владелец");
		
	Иначе
		Организация = ОбщегоНазначенияБПВызовСервера.УстановитьОтборПоОсновнойОрганизации(ЭтотОбъект, , "Владелец");
		
	КонецЕсли;
	
	Элементы.ГруппаОтборОрганизация.Видимость = Справочники.Организации.ИспользуетсяНесколькоОрганизаций();
	
	Период = ?(ЗначениеЗаполнено(Параметры.Период), Параметры.Период, ОбщегоНазначения.ТекущаяДатаПользователя());
	
	ВидПериода  = Перечисления.ДоступныеПериодыОтчета.Год;
	НачалоПериода = НачалоГода(Период);
	КонецПериода  = КонецГода(Период);
	
	ОтборПериодИспользование = Истина;
	ОтборПериод = ВыборПериодаКлиентСервер.ПолучитьПредставлениеПериодаОтчета(ВидПериода, НачалоПериода, КонецПериода);
	
	УстановитьОтборПоПериоду(ЭтотОбъект, НачалоПериода, КонецПериода, ОтборПериодИспользование);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодНачалоВыбораЗавершение(СтруктураПериода, ДополнительныеПараметры) Экспорт
	
	// Установим полученный период
	Если СтруктураПериода <> Неопределено Тогда
		ВидПериода = СтруктураПериода.ВидПериода;
		ОтборПериод = СтруктураПериода.Период;
		НачалоПериода = СтруктураПериода.НачалоПериода;
		КонецПериода = СтруктураПериода.КонецПериода;
	КонецЕсли;
	
	УстановитьОтборПоПериоду(ЭтотОбъект, НачалоПериода, КонецПериода, ОтборПериодИспользование);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборПериодИспользованиеПриИзменении(Элемент)
	
	УстановитьОтборПоПериоду(ЭтотОбъект, НачалоПериода, КонецПериода, ОтборПериодИспользование);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПериодНачалоВыбораЗавершение", ЭтотОбъект);
	
	ВыборПериодаКлиент.ПериодНачалоВыбора(ЭтотОбъект, Элемент, СтандартнаяОбработка, 
		ВидПериода, НачалоПериода, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ВыборПериодаКлиент.ПериодОбработкаВыбора(
		Элемент, ВыбранноеЗначение, СтандартнаяОбработка,
		ВидПериода, ОтборПериод, НачалоПериода, КонецПериода);
	
	УстановитьОтборПоПериоду(ЭтотОбъект, НачалоПериода, КонецПериода, ОтборПериодИспользование);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ВыборПериодаКлиент.ПериодАвтоПодбор(
		Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка,
		ВидПериода, ОтборПериод, НачалоПериода, КонецПериода);

КонецПроцедуры

&НаКлиенте
Процедура ПериодОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ВыборПериодаКлиент.ПериодОкончаниеВводаТекста(
		Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка,
		ВидПериода, ОтборПериод, НачалоПериода, КонецПериода);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если НЕ Копирование Тогда
		Отказ = Истина;
		
		ЗначенияЗаполнения = ОбщегоНазначенияБПВызовСервера.ЗначенияЗаполненияДинамическогоСписка(Список.КомпоновщикНастроек);
		Если ОтборПериодИспользование Тогда
			ЗначенияЗаполнения.Вставить("ДатаНачала",    НачалоПериода);
			ЗначенияЗаполнения.Вставить("ДатаОкончания", КонецПериода);
		КонецЕсли;
		
		ОткрытьФорму("Справочник.Патенты.ФормаОбъекта", Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения), ЭтотОбъект);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункци

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоПериоду(Форма, НачалоПериода, КонецПериода, Использование)
	
	ОтборКомпоновкиДанных = Форма.Список.КомпоновщикНастроек.Настройки.Отбор;
	
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(
		ОтборКомпоновкиДанных, "ДатаНачала");
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		ОтборКомпоновкиДанных, "ДатаНачала", НачалоПериода, ВидСравненияКомпоновкиДанных.БольшеИлиРавно, , Использование);
	
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(
		ОтборКомпоновкиДанных, "ДатаОкончания");
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		ОтборКомпоновкиДанных, "ДатаОкончания", КонецПериода, ВидСравненияКомпоновкиДанных.МеньшеИлиРавно, , Использование);
	
КонецПроцедуры

#КонецОбласти