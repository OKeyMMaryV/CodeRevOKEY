
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВидДеятельности = ?(ПустаяСтрока(Запись.КодВидаПродукции), 0, 1);
	
	СписокВыбораВидаПродукции = Элементы.КодВидаПродукции.СписокВыбора;
	РегистрыСведений.СведенияОбАлкогольнойПродукции.СписокВидовПродукции(СписокВыбораВидаПродукции);
	Если Не ПустаяСтрока(Запись.КодВидаПродукции) Тогда
		
		ЭлементСписка = СписокВыбораВидаПродукции.НайтиПоЗначению(Запись.КодВидаПродукции);
		Если ЭлементСписка <> Неопределено Тогда
			НаименованиеВидаПродукции = СтрЗаменить(ЭлементСписка.Представление, Запись.КодВидаПродукции + " - ", "");
		КонецЕсли;
		
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
			
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)

	Если ВидДеятельности = 1
	   И ПустаяСтрока(Запись.КодВидаПродукции) Тогда
	   
		ТекстСообщения = НСтр("ru = 'Поле ""%1"" не заполнено.'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения,
			Строка(Элементы.КодВидаПродукции.Заголовок));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Запись.КодВидаПродукции", , Отказ);
		
		// Других сообщений об ошибках не выдавать.
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("Запись"));
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидДеятельностиПриИзменении(Элемент)
	
	Если ВидДеятельности = 0 И Не ПустаяСтрока(Запись.КодВидаПродукции) Тогда
		
		КодВидаПродукции = Элементы.КодВидаПродукции;
		Запись.КодВидаПродукции = КодВидаПродукции.СписокВыбора[0].Значение;
		ОчисткаВидаПродукции();
		Модифицированность = Истина;
		
	Иначе
		
		УправлениеФормой(ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КодВидаПродукцииПриИзменении(Элемент)
	
	Если ПустаяСтрока(Запись.КодВидаПродукции) Тогда
		ОчисткаВидаПродукции();
		Возврат;
	КонецЕсли;
	
	ЭлементСписка = Элемент.СписокВыбора.НайтиПоЗначению(Запись.КодВидаПродукции);
	Если ЭлементСписка <> Неопределено Тогда
		НаименованиеВидаПродукции = СтрЗаменить(ЭлементСписка.Представление, Запись.КодВидаПродукции + " - ", "");
	Иначе
		НаименованиеВидаПродукции = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчисткаВидаПродукции()
	
	ВидДеятельности = 0;
	
	НаименованиеВидаПродукции = "";
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьПроизвольныйПериод(Команда)
	
	Диалог = Новый ДиалогРедактированияСтандартногоПериода;
	Диалог.Период.ДатаНачала    = Запись.Период;
	Диалог.Период.ДатаОкончания = Запись.ДатаОкончания;
	
	ДополнительныеПараметры = Новый Структура("Диалог", Диалог);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПроизвольныйПериодЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	Диалог.Показать(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Форма.Элементы.КодВидаПродукции.Доступность = (Форма.ВидДеятельности = 1);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПроизвольныйПериодЗавершение(Период, ДополнительныеПараметры) Экспорт
	
	Если Период = Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	Диалог = ДополнительныеПараметры.Диалог;
	Запись.Период = Диалог.Период.ДатаНачала;
	Запись.ДатаОкончания  = Диалог.Период.ДатаОкончания;

КонецПроцедуры

#КонецОбласти