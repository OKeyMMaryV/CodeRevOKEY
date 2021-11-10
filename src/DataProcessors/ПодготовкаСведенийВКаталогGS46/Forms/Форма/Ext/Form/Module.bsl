﻿#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения Экспорт;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СтранаМираРоссия = Справочники.СтраныМира.Россия;
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если (Не ОбщегоНазначения.ЭтоWindowsКлиент()) Тогда
		Отказ = Истина;
		ВызватьИсключение НСтр("ru = 'Работа с COM-объектами доступна только для операционной системы Windows'");
	КонецЕсли;
	
	ПравоРегистрацииШтрихкодов = ИнтеграцияИС.ПравоРегистрацииШтрихкодовНоменклатуры();
	Элементы.ФормаЗагрузить.Видимость    = ПравоРегистрацииШтрихкодов;
	Элементы.ФормаЗаписатьGTIN.Видимость = ПравоРегистрацииШтрихкодов;
	
	АдресМакета = ПоместитьВоВременноеХранилище(УправлениеПечатью.МакетПечатнойФормы("Обработка.ПодготовкаСведенийВКаталогGS46.ШаблонExcelПередачиСведенийВКаталогGS46_ru"), УникальныйИдентификатор);
	ЦветГиперссылки = ЦветаСтиля.ЦветГиперссылкиГосИС;
	ОбработатьПереданныеПараметры();
	
	ИнтеграцияИСПереопределяемый.ЗаполнитьСлужебныеРеквизитыВКоллекции(ЭтотОбъект, Объект.Товары);
	
	СобытияФормИСПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(ЭтотОбъект,
		"ТоварыХарактеристика", "Элементы.Товары.ТекущиеДанные.Номенклатура");
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ИнициализироватьКлассификаторы();
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеФайлаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ФайловаяСистемаКлиент.ОткрытьФайл(Объект.ИмяФайла);
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СобытияФормИСМПКлиентПереопределяемый.ПриИзмененииНоменклатуры(ЭтотОбъект,
		ТекущиеДанные, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВидыПродукции = Новый Массив;
	ВидыПродукции.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Обувная"));
	СобытияФормИСМПКлиентПереопределяемый.ПриНачалеВыбораНоменклатуры(Элемент,
		ТекущиеДанные, СтандартнаяОбработка, ВидыПродукции);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураСоздание(Элемент, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СобытияФормИСМПКлиентПереопределяемый.ПриСозданииНоменклатуры(ЭтотОбъект,
		ТекущиеДанные, СтандартнаяОбработка, ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Обувная"));
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СобытияФормИСМПКлиентПереопределяемый.ПриИзмененииХарактеристики(ЭтотОбъект,
		ТекущиеДанные, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СобытияФормИСМПКлиентПереопределяемый.ПриНачалеВыбораХарактеристики(Элемент,
		ТекущиеДанные, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаСоздание(Элемент, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СобытияФормИСМПКлиентПереопределяемый.ПриСозданииХарактеристики(ЭтотОбъект,
		ТекущиеДанные, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыGTINНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если Элементы.Товары.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Элемент.СписокВыбора.ЗагрузитьЗначения(
		МассивЗначенийGTINДляВыбора(Элементы.Товары.ТекущаяСтрока));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьGTIN(Команда)
	
	ЗаписатьGTINНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура Загрузить(Команда)

	ОчиститьСообщения();

	Попытка
		Excel = Новый COMОбъект("Excel.Application");
		Excel.AutomationSecurity = 3;
		Excel.DisplayAlerts      = 0;
	Исключение
		СообщениеОбОшибке = НСтр("ru = 'Не удалось подключиться к Excel.
		                               |Убедитесь, что на компьютере установлена программа Microsoft Excel.
		                               |Подробности:'") + " " + КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		ВызватьИсключение СообщениеОбОшибке;
	КонецПопытки;
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("Excel", Excel);
	
	Оповещение = Новый ОписаниеОповещения("ПослеВыбораФайлаДляЗагрузки", ЭтотОбъект, ДополнительныеПараметры);

	ДиалогВыбора = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбора.Фильтр = НСтр("ru = 'Файл Excel'") + "(*.xlsx)|*.xlsx";
	ДиалогВыбора.Показать(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
	
	ОчиститьСообщения();
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Попытка
		Excel = Новый COMОбъект("Excel.Application");
		Excel.AutomationSecurity = 3;
		Excel.DisplayAlerts      = 0;
	Исключение
		СообщениеОбОшибке = НСтр("ru = 'Не удалось подключиться к Excel.
		                               |Убедитесь, что на компьютере установлена программа Microsoft Excel.
		                               |Подробности:'") + " " + КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		ВызватьИсключение СообщениеОбОшибке;
	КонецПопытки;
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("Excel", Excel);
	
	ПараметрыСохранения = ФайловаяСистемаКлиент.ПараметрыСохраненияФайла();
	ПараметрыСохранения.Диалог.Фильтр = НСтр("ru = 'Файлы MS Excel (*.xlsx)|*.xlsx'");
	
	ФайловаяСистемаКлиент.СохранитьФайл(
		Новый ОписаниеОповещения("ПослеВыбораФайлаДляВыгрузки", ЭтотОбъект, ДополнительныеПараметры),
		АдресМакета,,
		ПараметрыСохранения);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьКолонкуТорговаяМарка(Команда)
	ЗаполнитьКолонку(Команда);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьКолонкуСтранаПроизводства(Команда)
	ЗаполнитьКолонку(Команда);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьКолонкуВидОбуви(Команда)
	ЗаполнитьКолонку(Команда);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьКолонкуМатериалВерха(Команда)
	ЗаполнитьКолонку(Команда);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьКолонкуМатериалПодкладки(Команда)
	ЗаполнитьКолонку(Команда);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьКолонкуМатериалНиза(Команда)
	ЗаполнитьКолонку(Команда);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьКолонкуЦвет(Команда)
	ЗаполнитьКолонку(Команда);
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция МассивЗначенийGTINДляВыбора(ТекущаяСтрока)
	
	ТекущиеДанные = Объект.Товары.НайтиПоИдентификатору(ТекущаяСтрока);
	
	Возврат ИнтеграцияИСМП.МассивЗначенийGTINДляВыбора(ТекущиеДанные, ЭтотОбъект);
	
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	СобытияФормИСПереопределяемый.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(
		ЭтотОбъект, "ТоварыХарактеристика", "Объект.Товары.ХарактеристикиИспользуются");
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыЦвет.Имя);
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыРазмер.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Объект.Товары.СтранаПроизводства");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = СтранаМираРоссия;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьПереданныеПараметры()
	
	Если ТипЗнч(Параметры.Товары) = Тип("Массив") Тогда
		Для Каждого ЭлементМассива Из Параметры.Товары Цикл
			НоваяСтрока = Объект.Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ЭлементМассива);
			СобытияФормИСМППереопределяемый.ПриИзмененииНоменклатуры(ЭтотОбъект,
				НоваяСтрока, Неопределено);
		КонецЦикла;
	КонецЕсли;
	
	Объект.Организация = Параметры.Организация;
	Объект.ДатаПубликации = Параметры.ДатаПубликации;
	
	ИнтеграцияИСМППереопределяемый.ЗаполнитьСвойстваНоменклатурыДляКаталогаGS46(Объект.Товары);
	
	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		ОрганизацияПриИзмененииНаСервере();
	КонецЕсли;
	
	Элементы.ЗаполнитьКолонку.Доступность = Объект.Товары.Количество();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораФайлаДляВыгрузки(ВыбранныеФайлы, ПараметрыФормирования) Экспорт
	
	Если ВыбранныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ВыбранныеФайлы.Количество() Тогда
		Объект.ИмяФайла = ВыбранныеФайлы[0].ПолноеИмя;
	КонецЕсли;
	
	Excel = ПараметрыФормирования.Excel;
	ДатаПубликации = Формат(Объект.ДатаПубликации,"ДФ=dd.MM.yyyy;");
	
	Попытка
		
		Workbook = Excel.workbooks.Open(Объект.ИмяФайла);
		
		Sheet = Workbook.Worksheets(1);
		
		НомерСтроки = 7;
		
		ДополнительныеСведения = ДополнительныеСведенияПродукции();
		
		Для Каждого СтрокаТовары Из Объект.Товары Цикл
			Sheet.Rows(СтрШаблон("%1:%1", НомерСтроки)).NumberFormat = "@";
			
			Если Не ПустаяСтрока(СтрокаТовары.GTIN) Тогда
				Sheet.Cells(НомерСтроки, 2).Value = СтрокаТовары.GTIN;
			КонецЕсли;
			
			Если Не (СтрокаТовары.Характеристика = Неопределено) Тогда
				Sheet.Cells(НомерСтроки, 3).Value = ДополнительныеСведения.Представления[СтрокаТовары.Номенклатура][СтрокаТовары.Характеристика];
			Иначе
				Sheet.Cells(НомерСтроки, 3).Value = ДополнительныеСведения.Представления[СтрокаТовары.Номенклатура]["Представление"];
			КонецЕсли;
			Sheet.Cells(НомерСтроки, 4).Value = ДополнительныеСведения.Артикулы[СтрокаТовары.Номенклатура];
			Sheet.Cells(НомерСтроки, 5).Value = ДатаПубликации;
			Sheet.Cells(НомерСтроки, 6).Value = СтрокаТовары.Наименование;
			
			Если Не ПустаяСтрока(СтрокаТовары.ТорговаяМарка) Тогда
				Sheet.Cells(НомерСтроки, 7).Value = СтрокаТовары.ТорговаяМарка;
			Иначе
				Sheet.Cells(НомерСтроки, 7).Value = НСтр("ru='отсутствует'", "ru");
			КонецЕсли;
			
			Sheet.Cells(НомерСтроки, 8).Value = СтрокаТовары.ИННПроизводителя;
			
			Если ЗначениеЗаполнено(СтрокаТовары.СтранаПроизводства) Тогда
				Sheet.Cells(НомерСтроки, 9).Value = ДополнительныеСведения.КодыАльфа2[СтрокаТовары.СтранаПроизводства];
			КонецЕсли;
			
			Если ЗначениеЗаполнено(СтрокаТовары.ВидОбуви) Тогда
				Sheet.Cells(НомерСтроки, 10).Value = ДополнительныеСведения.ВидыОбуви[СтрокаТовары.ВидОбуви];
			КонецЕсли;
	
			Sheet.Cells(НомерСтроки, 11).Value = СтрокаТовары.МатериалВерха;
			Sheet.Cells(НомерСтроки, 12).Value = СтрокаТовары.МатериалПодкладки;
			Sheet.Cells(НомерСтроки, 13).Value = СтрокаТовары.МатериалНиза;
			Sheet.Cells(НомерСтроки, 14).Value = СтрокаТовары.Цвет;
			
			Если ЗначениеЗаполнено(СтрокаТовары.Размер) Тогда
				Sheet.Cells(НомерСтроки, 15).Value = ДополнительныеСведения.РазмерыОбуви[СтрокаТовары.Размер];
			КонецЕсли;
			
			Если ЗначениеЗаполнено(СтрокаТовары.КодТНВЭД) Тогда
				Sheet.Cells(НомерСтроки, 16).Value = ДополнительныеСведения.КодыТНВЭД[СтрокаТовары.КодТНВЭД];
			КонецЕсли;
			
			НомерСтроки = НомерСтроки + 1;
		КонецЦикла;
		
		Workbook.Save();
		Workbook.Close(0);
		
		Excel.Quit();
		Excel = 0;

		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Сформирован файл сведений в Excel.'"),,, БиблиотекаКартинок.ФорматExcel,
			СтатусОповещенияПользователя.Информация, ЭтотОбъект.УникальныйИдентификатор);
		
		УстановитьОписаниеФайла(НСтр("ru = 'Открыть файл выгрузки'"));
		
		Элементы.ЗаполнитьКолонку.Доступность = Объект.Товары.Количество();
		
	Исключение
		
		Excel.Quit();
		Excel = 0;
		
		СообщениеОбОшибке = НСтр("ru = 'Не удалось выгрузить сведения в Excel.
		                               |Подробности:'") + " " + КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		ВызватьИсключение СообщениеОбОшибке;
		
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Функция ДополнительныеСведенияПродукции()
	
	Сведения = Новый Структура();
	Сведения.Вставить("Артикулы",      Новый Соответствие);
	Сведения.Вставить("КодыАльфа2",    Новый Соответствие);
	Сведения.Вставить("ВидыОбуви",     Новый Соответствие);
	Сведения.Вставить("РазмерыОбуви",  Новый Соответствие);
	Сведения.Вставить("КодыТНВЭД",     Новый Соответствие);
	Сведения.Вставить("Представления", Новый Соответствие);
	
	Продукция  = Новый Массив;
	СтраныМира = Новый Массив;

	Для Каждого СтрокаТовары Из Объект.Товары Цикл
		Если Продукция.Найти(СтрокаТовары.Номенклатура) = Неопределено Тогда
			Продукция.Добавить(СтрокаТовары.Номенклатура);
		КонецЕсли;
			
		Если ЗначениеЗаполнено(СтрокаТовары.СтранаПроизводства)
			И СтраныМира.Найти(СтрокаТовары.СтранаПроизводства) = Неопределено Тогда
			СтраныМира.Добавить(СтрокаТовары.СтранаПроизводства);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СтрокаТовары.ВидОбуви)
			И Сведения.ВидыОбуви[СтрокаТовары.ВидОбуви] = Неопределено Тогда
			ЗначениеКлассификатора = ЗначениеКлассификатораПоИмени(ВидыОбуви, СтрокаТовары.ВидОбуви);
			Сведения.ВидыОбуви.Вставить(СтрокаТовары.ВидОбуви, ЗначениеКлассификатора);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СтрокаТовары.Размер)
			И Сведения.РазмерыОбуви[СтрокаТовары.Размер] = Неопределено Тогда
			ЗначениеКлассификатора = ЗначениеКлассификатораПоИмени(РазмерыОбуви, СтрокаТовары.Размер);
			Сведения.РазмерыОбуви.Вставить(СтрокаТовары.Размер, ЗначениеКлассификатора);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СтрокаТовары.КодТНВЭД)
			И Сведения.КодыТНВЭД[СтрокаТовары.КодТНВЭД] = Неопределено Тогда
			ЗначениеКлассификатора = ЗначениеКлассификатораПоИмени(КодыТНВЭД, СтрокаТовары.КодТНВЭД);
			Сведения.КодыТНВЭД.Вставить(СтрокаТовары.КодТНВЭД, ЗначениеКлассификатора);
		КонецЕсли;
		
		Номенклатура = Сведения.Представления.Получить(СтрокаТовары.Номенклатура);
		Если Номенклатура = Неопределено Тогда
			Номенклатура = Новый Соответствие;
			Сведения.Представления.Вставить(СтрокаТовары.Номенклатура, Номенклатура);
		КонецЕсли;
		
		Если СтрокаТовары.Характеристика <> Неопределено Тогда
			Номенклатура.Вставить(СтрокаТовары.Характеристика, СтрШаблон("%1%2", XMLСтрока(СтрокаТовары.Номенклатура), XMLСтрока(СтрокаТовары.Характеристика)));
		Иначе
			Номенклатура.Вставить("Представление", XMLСтрока(СтрокаТовары.Номенклатура));
		КонецЕсли;
		
	КонецЦикла;
	
	Сведения.Артикулы = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(Продукция, "Артикул");
	
	Если СтраныМира.Количество() > 0 Тогда
		Сведения.КодыАльфа2 = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(СтраныМира, "КодАльфа2");
	КонецЕсли;
	
	Возврат Сведения;
	
КонецФункции

&НаСервере
Функция ЗначениеКлассификатораПоИмени(Классификатор, ИмяЗначения)
	
	СтрокаКлассификатора = Классификатор.НайтиСтроки(Новый Структура("Представление", ИмяЗначения));
	
	Если СтрокаКлассификатора.Количество() Тогда
		Значение = СтрокаКлассификатора[0].Значение;
	Иначе
		Значение = ИмяЗначения;
	КонецЕсли;
	
	Возврат Значение;
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьКолонку(Команда)
	
	ИмяКолонки = СтрЗаменить(Команда.Имя, "ЗаполнитьКолонку", "");
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗаполнитьКолонкуЗавершение", ЭтотОбъект, Новый Структура("ИмяКолонки", ИмяКолонки));
	
	Если ИмяКолонки = "ВидОбуви" Или ИмяКолонки = "Размер" Тогда
		ПоказатьВыборИзСписка(ОписаниеОповещения, Элементы["Товары"+ИмяКолонки].СписокВыбора, Элементы["Товары"+ИмяКолонки]);
		Возврат;
	КонецЕсли;
	
	ТипКолонки = Новый ОписаниеТипов("Строка");
	
	Если ИмяКолонки = "СтранаПроизводства" Тогда
		ТипКолонки = Новый ОписаниеТипов("СправочникСсылка.СтраныМира");
	КонецЕсли;
	
	ЗаголовокВводаЗначения = НСтр("ru = 'Введите значение заполнения'");
	ПоказатьВводЗначения(ОписаниеОповещения, , ЗаголовокВводаЗначения, ТипКолонки);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьКолонкуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Результат) = Тип("ЭлементСпискаЗначений") Тогда
		Результат = Результат.Значение;
	КонецЕсли;
	
	ИмяКолонки = ДополнительныеПараметры.ИмяКолонки;
	ЗаполнитьКолонкуНаСервере(Результат, ИмяКолонки);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКолонкуНаСервере(ЗначениеЗаполнения, ИмяКолонки)
	
	Для Каждого СтрокаТаблицы Из Объект.Товары Цикл
		СтрокаТаблицы[ИмяКолонки] = ЗначениеЗаполнения;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	ИНН = ИнтеграцияИСВызовСервера.ИННКПППоОрганизацииКонтрагенту(Объект.Организация).ИНН;
	ЗаполнитьКолонкуНаСервере(ИНН, "ИННПроизводителя");
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПослеУдаления(Элемент)
	
	Элементы.ЗаполнитьКолонку.Доступность = Объект.Товары.Количество();
	
КонецПроцедуры

#Область Загрузка

&НаКлиенте
Процедура ПослеВыбораФайлаДляЗагрузки(ВыбранныеФайлы, ПараметрыФормирования) Экспорт
	
	Если ВыбранныеФайлы<> Неопределено И ВыбранныеФайлы.Количество() = 1 Тогда
		Объект.ИмяФайла = ВыбранныеФайлы[0];
	Иначе
		Возврат;
	КонецЕсли;
	
	РезультатЗагрузки = Новый Массив;
	
	Excel = ПараметрыФормирования.Excel;
	
	Попытка
		
		Workbook = Excel.workbooks.Open(Объект.ИмяФайла);
		
		Sheet = Workbook.Worksheets(1);
	
		Для НомерСтроки = 7 По Sheet.UsedRange.Rows.Count Цикл
			Если ВРег(Sheet.Cells(НомерСтроки, 17).Value) = ВРег("OK") Тогда
				ДанныеСтроки = Новый Структура;
				ДанныеСтроки.Вставить("GTIN",               Формат(Sheet.Cells(НомерСтроки, 2).Value, "ЧГ=0;"));
				ДанныеСтроки.Вставить("GUID",               СокрЛП(Sheet.Cells(НомерСтроки, 3).Value));
				ДанныеСтроки.Вставить("Артикул",            Sheet.Cells(НомерСтроки, 4).Value);
				ДанныеСтроки.Вставить("ДатаПубликации",     Sheet.Cells(НомерСтроки, 5).Value);
				ДанныеСтроки.Вставить("Наименование",       Sheet.Cells(НомерСтроки, 6).Value);
				ДанныеСтроки.Вставить("ТорговаяМарка",      Sheet.Cells(НомерСтроки, 7).Value);
				ДанныеСтроки.Вставить("ИННПроизводителя",   Формат(Sheet.Cells(НомерСтроки, 8).Value, "ЧГ=0;"));
				ДанныеСтроки.Вставить("СтранаПроизводства", Sheet.Cells(НомерСтроки, 9).Value);
				ДанныеСтроки.Вставить("ВидОбуви",           Sheet.Cells(НомерСтроки, 10).Value);
				ДанныеСтроки.Вставить("МатериалВерха",      Sheet.Cells(НомерСтроки, 11).Value);
				ДанныеСтроки.Вставить("МатериалПодкладки",  Sheet.Cells(НомерСтроки, 12).Value);
				ДанныеСтроки.Вставить("МатериалНиза",       Sheet.Cells(НомерСтроки, 13).Value);
				ДанныеСтроки.Вставить("Цвет",               Sheet.Cells(НомерСтроки, 14).Value);
				ДанныеСтроки.Вставить("Размер",             Sheet.Cells(НомерСтроки, 15).Value);
				ДанныеСтроки.Вставить("КодТНВЭД",           Sheet.Cells(НомерСтроки, 16).Value);
				РезультатЗагрузки.Добавить(ДанныеСтроки);
			КонецЕсли;
		КонецЦикла;
		
		Excel.Quit();
		Excel = 0;
		
		УстановитьОписаниеФайла(НСтр("ru = 'Открыть исходный файл'"));
		
	Исключение
		
		Excel.Quit();
		Excel = 0;
		
		СообщениеОбОшибке = НСтр("ru = 'Не удалось загрузить сведения из Excel.
		                               |Подробности:'") + " " + КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		ВызватьИсключение СообщениеОбОшибке;
		
	КонецПопытки;
	
	Если РезультатЗагрузки.Количество() = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Файл не прошел обработку в GS46'"), 30);
	ИначеЕсли ПроверитьЗагрузитьТовары(РезультатЗагрузки) Тогда
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Загружен файл сведений из Excel. Проверьте полученные сведения и загрузите GTIN в информационную базу.'"),,,,
			СтатусОповещенияПользователя.Информация,
			ЭтотОбъект.УникальныйИдентификатор);
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Функция ПроверитьЗагрузитьТовары(РезультатЗагрузки)
	
	Отказ = Ложь;
	МассивНоменклатурыДляПроверки = Новый Массив;
	
	ТипНоменклатура = Метаданные.ОпределяемыеТипы.Номенклатура.Тип;
	ПустаяСсылкаНоменклатура = ТипНоменклатура.ПривестиЗначение(Неопределено);
	Если (ПустаяСсылкаНоменклатура = Неопределено) Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Загрузка GTIN для составного типа номенклатуры не предусмотрена'"));
		Возврат Ложь;
	ИначеЕсли Метаданные.НайтиПоТипу(ТипЗнч(ПустаяСсылкаНоменклатура)) = Неопределено Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Загрузка GTIN для нессылочного типа номенклатуры не предусмотрена'"));
		Возврат Ложь;
	КонецЕсли;
	ТипНоменклатура = ТипНоменклатура.Типы()[0];
	
	ТипХарактеристика = Метаданные.ОпределяемыеТипы.ХарактеристикаНоменклатуры.Тип;
	ПустаяСсылкаХарактеристика = ТипХарактеристика.ПривестиЗначение(Неопределено);
	МенеджерХарактеристика = Неопределено;
	Если (ПустаяСсылкаХарактеристика = Неопределено) Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Загрузка GTIN для составного типа характеристики не предусмотрена'"));
		Возврат Ложь;
	ИначеЕсли Метаданные.НайтиПоТипу(ТипЗнч(ПустаяСсылкаХарактеристика)) <> Неопределено Тогда
		МенеджерХарактеристика = ОбщегоНазначения.МенеджерОбъектаПоСсылке(ПустаяСсылкаХарактеристика);
	КонецЕсли;
	ТипХарактеристика = ТипХарактеристика.Типы()[0];

	МассивНоменклатурыДляПроверки  = Новый Массив;
	МассивХарактеристикДляПроверки = Новый Массив;
	Попытка
		Для Каждого СтрокаТовар Из РезультатЗагрузки Цикл
			ДлинаИндентификатора = СтрДлина(СтрокаТовар.GUID);
			Если ДлинаИндентификатора = 36 Тогда
				СтрокаТовар.Вставить("Номенклатура", XMLЗначение(ТипНоменклатура,СтрокаТовар.GUID));
				СтрокаТовар.Вставить("Характеристика", Неопределено);
				Если МассивНоменклатурыДляПроверки.Найти(СтрокаТовар.Номенклатура) = Неопределено Тогда
					МассивНоменклатурыДляПроверки.Добавить(СтрокаТовар.Номенклатура);
				КонецЕсли;
			ИначеЕсли ДлинаИндентификатора > 36 Тогда
				СтрокаТовар.Вставить("Номенклатура", XMLЗначение(ТипНоменклатура,Лев(СтрокаТовар.GUID,36)));
				СтрокаТовар.Вставить("Характеристика", XMLЗначение(ТипХарактеристика, Сред(СтрокаТовар.GUID,37)));
				Если МассивНоменклатурыДляПроверки.Найти(СтрокаТовар.Номенклатура) = Неопределено Тогда
					МассивНоменклатурыДляПроверки.Добавить(СтрокаТовар.Номенклатура);
				КонецЕсли;
				Если МенеджерХарактеристика <> Неопределено Тогда
					Если МассивХарактеристикДляПроверки.Найти(СтрокаТовар.Характеристика) = Неопределено
						И СтрокаТовар.Характеристика <> ПустаяСсылкаХарактеристика Тогда
						МассивХарактеристикДляПроверки.Добавить(СтрокаТовар.Характеристика);
					КонецЕсли;
				КонецЕсли;
			Иначе
				ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Распознание номенклатуры и характеристики по входящему идентификатору невозможно'"));
				Отказ = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	Исключение
		Отказ = Истина;
		ОбщегоНазначения.СообщитьПользователю(СтрШаблон(
			НСтр("ru = 'При распознании данных Excel произошла ошибка: %1'"), ОписаниеОшибки()));
	КонецПопытки;
	
	Если Отказ Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если МассивНоменклатурыДляПроверки.Количество() Тогда
		Ссылки = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(МассивНоменклатурыДляПроверки, "Ссылка");
		Если Ссылки.Количество()<>МассивНоменклатурыДляПроверки.Количество() Тогда
			ОбщегоНазначения.СообщитьПользователю(СтрШаблон(
				НСтр("ru = 'При распознании данных Excel произошла ошибка: распознано %1 позиций номенклатуры из %2'"), 
				Ссылки.Количество(),
				МассивНоменклатурыДляПроверки.Количество()));
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если МассивХарактеристикДляПроверки.Количество() Тогда
		Ссылки = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(МассивХарактеристикДляПроверки, "Ссылка");
		Если Ссылки.Количество()<>МассивХарактеристикДляПроверки.Количество() Тогда
			ОбщегоНазначения.СообщитьПользователю(СтрШаблон(
				НСтр("ru = 'При распознании данных Excel произошла ошибка: распознано %1 характеристик номенклатуры из %2'"), 
				Ссылки.Количество(),
				МассивХарактеристикДляПроверки.Количество()));
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Объект.Товары.Очистить();
	Для Каждого СтрокаТовар Из РезультатЗагрузки Цикл
		ЗаполнитьЗначенияСвойств(Объект.Товары.Добавить(), СтрокаТовар);
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Процедура ЗаписатьGTINНаСервере()
	
	ИнтеграцияИСМППереопределяемый.ЗагрузитьПолученныеGTINКаталогаGS46(Объект.Товары);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаКлиенте
Процедура ИнициализироватьКлассификаторы()
	
	ПараметрыСохранения = ФайловаяСистемаКлиент.ПараметрыСохраненияФайла();
	ПараметрыСохранения.Интерактивно = Ложь;
	Объект.ИмяФайла = КаталогВременныхФайлов() + "template.xlsx";
	ФайловаяСистемаКлиент.СохранитьФайл(
		Новый ОписаниеОповещения("ИнициализироватьКлассификаторыЗавершение",ЭтотОбъект),
		АдресМакета, Объект.ИмяФайла, ПараметрыСохранения)
	
КонецПроцедуры

&НаКлиенте
Процедура ИнициализироватьКлассификаторыЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Не(Результат = Неопределено) Тогда
		Объект.ИмяФайла = Результат[0].ПолноеИмя;
	Иначе
		Возврат;
	КонецЕсли;
	
	ВидыОбуви.Очистить();
	РазмерыОбуви.Очистить();
	
	Элементы.ТоварыВидОбуви.СписокВыбора.Очистить();
	Элементы.ТоварыРазмер.СписокВыбора.Очистить();
	
	Попытка
		Excel = Новый COMОбъект("Excel.Application");
		Excel.AutomationSecurity = 3;
		Excel.DisplayAlerts      = 0;
	Исключение
		СообщениеОбОшибке = НСтр("ru = 'Не удалось подключиться к Excel.
		                               |Убедитесь, что на компьютере установлена программа Microsoft Excel.
		                               |Подробности:'") + " " + КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		ВызватьИсключение СообщениеОбОшибке;
	КонецПопытки;
	
	Попытка
		Workbook = Excel.workbooks.Open(Объект.ИмяФайла);
		Sheet = Workbook.Worksheets(2);
		
		ПредставленияВидыОбуви = Новый Массив;
		ПредставленияРазмеры   = Новый Массив;
		ПредставленияКодыТНВЭД = Новый Массив;
		
		Для НомерСтроки = 2 По Sheet.UsedRange.Rows.Count Цикл
			Если ЗначениеЗаполнено(Sheet.Cells(НомерСтроки, 2).Value) Тогда
				СтрокаВидОбуви = ВидыОбуви.Добавить();
				СтрокаВидОбуви.Значение = Sheet.Cells(НомерСтроки, 2).Value;
				СтрокаВидОбуви.Представление = СокрЛП(Сред(СтрокаВидОбуви.Значение, Найти(СтрокаВидОбуви.Значение, ">")+1));
				Элементы.ТоварыВидОбуви.СписокВыбора.Добавить(СтрокаВидОбуви.Представление);
				ПредставленияВидыОбуви.Добавить(СтрокаВидОбуви.Значение);
				ПредставленияВидыОбуви.Добавить(СтрокаВидОбуви.Представление);
			КонецЕсли;
			Если ЗначениеЗаполнено(Sheet.Cells(НомерСтроки, 3).Value) Тогда
				СтрокаРазмерОбуви = РазмерыОбуви.Добавить();
				СтрокаРазмерОбуви.Значение = Sheet.Cells(НомерСтроки, 3).Value;
				СтрокаРазмерОбуви.Представление = СокрЛП(Сред(СтрокаРазмерОбуви.Значение, Найти(СтрокаРазмерОбуви.Значение, ">")+1));
				Элементы.ТоварыРазмер.СписокВыбора.Добавить(СтрокаРазмерОбуви.Представление);
				ПредставленияРазмеры.Добавить(СтрокаРазмерОбуви.Значение);
				ПредставленияРазмеры.Добавить(СтрокаРазмерОбуви.Представление);
			КонецЕсли;
			Если ЗначениеЗаполнено(Sheet.Cells(НомерСтроки, 4).Value) Тогда
				СтрокаКодТНВЭД = КодыТНВЭД.Добавить();
				СтрокаКодТНВЭД.Значение = Sheet.Cells(НомерСтроки, 4).Value;
				СтрокаКодТНВЭД.Представление = СокрЛП(Сред(
					СтрокаКодТНВЭД.Значение, Найти(СтрокаКодТНВЭД.Значение, "<")+1, Найти(СтрокаКодТНВЭД.Значение, ">")-Найти(СтрокаКодТНВЭД.Значение, "<")-1));
				Элементы.ТоварыКодТНВЭД.СписокВыбора.Добавить(СтрокаКодТНВЭД.Представление);
				ПредставленияКодыТНВЭД.Добавить(СтрокаКодТНВЭД.Значение);
				ПредставленияКодыТНВЭД.Добавить(СтрокаКодТНВЭД.Представление);
			КонецЕсли;
		КонецЦикла;
		
		Для Каждого СтрокаТаблицы Из Объект.Товары Цикл
			Если ПредставленияВидыОбуви.Найти(СтрокаТаблицы.ВидОбуви) = Неопределено Тогда
				СтрокаТаблицы.ВидОбуви = Неопределено;
			КонецЕсли;
			Если ПредставленияРазмеры.Найти(СтрокаТаблицы.Размер) = Неопределено Тогда
				СтрокаТаблицы.Размер = Неопределено;
			КонецЕсли;
			Если ПредставленияКодыТНВЭД.Найти(СтрокаТаблицы.КодТНВЭД) = Неопределено Тогда
				СтрокаТаблицы.КодТНВЭД = Неопределено;
			КонецЕсли;
		КонецЦикла;
	
		Excel.Quit();
		Excel = 0;
		
		УстановитьОписаниеФайла(НСтр("ru = 'Открыть шаблон'"));
		
	Исключение
		
		Excel.Quit();
		Excel = 0;
		
		СообщениеОбОшибке = НСтр("ru = 'Не удалось загрузить классификаторы из Excel.
		                               |Подробности:'") + " " + КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		ВызватьИсключение СообщениеОбОшибке;
		
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОписаниеФайла(Описание)
	
	ОписаниеФайла = Новый ФорматированнаяСтрока(Описание,, ЦветГиперссылки,, "ОткрытьФайл");
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти