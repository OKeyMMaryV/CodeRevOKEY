﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры.Отбор);
	
	ИспользуетсяНесколькоОрганизаций = Справочники.Организации.ИспользуетсяНесколькоОрганизаций();
	
	РегистрыУчетаВызовСервера.УстановитьВидимостьКомандСохранения(ЭтотОбъект);
	
	ОбновитьОтбор(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НачалоПериодаПриИзменении(Элемент)
	
	ОбновитьОтбор(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура КонецПериодаПриИзменении(Элемент)
	
	ОбновитьОтбор(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОбновитьОтбор(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ВидРегистраПриИзменении(Элемент)
	
	ОбновитьОтбор(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СвойстваПрисоединенногоФайла = ПолучитьСвойстваПрисоединенногоФайла(ВыбраннаяСтрока);
	Если НЕ СвойстваПрисоединенногоФайла.ФайлРегистраУчетаПрисоединен = Истина Тогда
		
		СообщениеОбОшибке = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='%1 не содержит присоединенного файла'"), 
				 СвойстваПрисоединенногоФайла.РегистрУчета);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке, СвойстваПрисоединенногоФайла.РегистрУчета);
		Возврат;
		
	КонецЕсли;
	
	РаботаСФайламиКлиент.ОткрытьФайл(СвойстваПрисоединенногоФайла.ДанныеФайла);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьПериод(Команда)
	
	ПараметрыВыбора = Новый Структура("НачалоПериода,КонецПериода", НачалоПериода, КонецПериода);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериода", ПараметрыВыбора, Элементы.ВыбратьПериод, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодписатьЭЦП(Команда)
	
	Если Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		
		СвойстваПрисоединенногоФайла = ПолучитьСвойстваПрисоединенногоФайла(Элементы.Список.ТекущиеДанные.Ссылка);
		Если НЕ СвойстваПрисоединенногоФайла.ФайлРегистраУчетаПрисоединен = Истина Тогда
			
			СообщениеОбОшибке = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='%1 не содержит присоединенного файла'"), 
			СвойстваПрисоединенногоФайла.РегистрУчета);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке, СвойстваПрисоединенногоФайла.РегистрУчета);
			Возврат;
			
		КонецЕсли;
		
		Если СвойстваПрисоединенногоФайла.ИспользоватьЭП <> Истина Тогда
			СообщениеОбОшибке = НСтр("ru='Для подписи регистра включите использование ЭП в настройках программы'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке, СвойстваПрисоединенногоФайла.РегистрУчета);
			Возврат;
		КонецЕсли;
		
		Если СвойстваПрисоединенногоФайла.ПодписанЭП = Истина Тогда
			СообщениеОбОшибке = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='%1 уже подписан ЭЦП'"), 
			СвойстваПрисоединенногоФайла.РегистрУчета);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке, СвойстваПрисоединенногоФайла.РегистрУчета);
			Возврат;
		КонецЕсли;
		
		РаботаСФайламиКлиент.ПодписатьФайл(СвойстваПрисоединенногоФайла.ПрисоединенныйФайл, УникальныйИдентификатор);	
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СохранитьВместеСЭЦП(Команда)
	
	Если Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		СвойстваПрисоединенногоФайла = ПолучитьСвойстваПрисоединенногоФайла(Элементы.Список.ТекущиеДанные.Ссылка);
		
		Если СвойстваПрисоединенногоФайла.ФайлРегистраУчетаПрисоединен Тогда
			Если СвойстваПрисоединенногоФайла.ПодписанЭП Тогда
				РаботаСФайламиКлиент.СохранитьВместеСЭП(
					СвойстваПрисоединенногоФайла.ПрисоединенныйФайл,
					УникальныйИдентификатор);
			Иначе
				РаботаСФайламиКлиент.СохранитьФайлКак(СвойстваПрисоединенногоФайла.ДанныеФайла);
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьОтбор(Форма)
	
	// Обработка быстрых отборов
	
	Список = Форма.Список;
	Список.Отбор.Элементы.Очистить();
	
	Если ЗначениеЗаполнено(Форма.Организация) И (Форма.ИспользуетсяНесколькоОрганизаций) Тогда
	
		Отбор = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Организация");
		Отбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		Отбор.ПравоеЗначение = Форма.Организация;
		
	КонецЕсли; 
	
	Если ЗначениеЗаполнено(Форма.НачалоПериода) Тогда
	
		Отбор = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НачалоПериода");
		Отбор.ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
		Отбор.ПравоеЗначение = Форма.НачалоПериода;
		
	КонецЕсли; 
	
	Если ЗначениеЗаполнено(Форма.КонецПериода) Тогда
	
		Отбор = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("КонецПериода");
		Отбор.ВидСравнения = ВидСравненияКомпоновкиДанных.МеньшеИлиРавно;
		Отбор.ПравоеЗначение = Форма.КонецПериода;
		
	КонецЕсли; 
		
	Если ЗначениеЗаполнено(Форма.ВидРегистра) Тогда
	
		Отбор = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВидРегистра");
		Отбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		Отбор.ПравоеЗначение = Форма.ВидРегистра;
		
	КонецЕсли; 
	
КонецПроцедуры	

&НаСервере
Функция ПолучитьСвойстваПрисоединенногоФайла(ДокументРегистр)
	
	СвойстваФайла = Документы.РегистрУчета.ПолучитьСвойстваПрисоединенногоФайлаРегистра(ДокументРегистр, Истина);
	
	СвойстваФайла.Вставить("РегистрУчета",   ДокументРегистр);
	СвойстваФайла.Вставить("ИспользоватьЭП", ПолучитьФункциональнуюОпцию("ИспользоватьЭлектронныеПодписи"));
	
	Возврат СвойстваФайла;
	
КонецФункции

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, РезультатВыбора, "НачалоПериода,КонецПериода");
	
	ОбновитьОтбор(ЭтаФорма);

КонецПроцедуры


#КонецОбласти 
