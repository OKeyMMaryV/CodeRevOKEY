
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЕстьПравоПодбора = Истина;
	
	ЭтоСоставноеОС = Параметры.ЭтоСоставноеОС;
	Если ЗначениеЗаполнено(Параметры.ТекущийДокумент) Тогда
		ЕстьПравоПодбора = ПравоДоступа("Изменение", Параметры.ТекущийДокумент.Метаданные());
	КонецЕсли;

	Количество = Параметры.Количество;
	АдресТаблицыРНПТВХранилище = Параметры.АдресТаблицыРНПТВХранилище;
	
	Запрос = Новый Запрос();
	Если ЭтоСоставноеОС Тогда 
		Запрос.Текст = ТекстЗапросаПринятиеКУчетуОСОбъектСтроительства();
		Запрос.УстановитьПараметр("ОбъектСтроительства", Параметры.ОбъектСтроительства);
	Иначе
		Запрос.Текст = ТекстЗапросаПринятиеКУчетуОСОборудование();
		Запрос.УстановитьПараметр("Номенклатура", Параметры.Номенклатура);
	КонецЕсли;
	Запрос.УстановитьПараметр("Организация",         Параметры.Организация);
	Запрос.УстановитьПараметр("Период",
		Новый Граница(КонецДня(Параметры.Период), ВидГраницы.Включая));
	Результат = Запрос.Выполнить().Выгрузить();
	Остатки.Загрузить(Результат);

	ТаблицаРНПТ = ПолучитьИзВременногоХранилища(ЭтотОбъект.АдресТаблицыРНПТВХранилище);
	
	Подбор.Очистить();
	Подбор.Загрузить(ТаблицаРНПТ);
	КоличествоПодобрано = Подбор.Итог("Количество");

	Если ЗначениеЗаполнено(Параметры.Номенклатура) Тогда
		СвойстваНоменклатуры = 
		ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Параметры.Номенклатура, "ЕдиницаИзмерения, КодТНВЭД.ЕдиницаИзмерения");
		РазныеЕдиницыИзмерения = СвойстваНоменклатуры.ЕдиницаИзмерения <> СвойстваНоменклатуры.КодТНВЭДЕдиницаИзмерения;
	Иначе
		РазныеЕдиницыИзмерения = Ложь;
	КонецЕсли;
	
	Если ЭтоСоставноеОС Тогда
		Заголовок = НСтр("ru = 'Данные по РНПТ'");
	Иначе
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'РНПТ: %1'"),
		Параметры.Номенклатура);
	КонецЕсли;
	
	ЭтаФорма.ТолькоПросмотр = НЕ ЕстьПравоПодбора;
	ЭтаФорма.Элементы.ПеренестиВДокумент.Доступность = ЕстьПравоПодбора;
	ЭтаФорма.Элементы.ОстаткиВыбрать.Доступность     = ЕстьПравоПодбора;
	ЭтаФорма.Элементы.Остатки.Доступность            = ЕстьПравоПодбора;
	ЭтаФорма.Элементы.Подбор.Доступность             = ЕстьПравоПодбора;
	Элементы.ОстаткиНоменклатура.Видимость           = ЭтоСоставноеОС;
	Элементы.ПодборНоменклатура.Видимость            = ЭтоСоставноеОС;
		
	УстановитьЗаголовкиКолонок(СвойстваНоменклатуры);
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы И Модифицированность Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ЕстьОшибки = Ложь;
	Если Подбор.Количество() <> 0
		И Модифицированность Тогда
		
		Если НЕ ЭтоСоставноеОС Тогда
			Если КоличествоПодобрано > Количество Тогда
				ЕстьОшибки = Истина;
				ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
				"Список", 
				"Корректность",,,
				НСтр("ru = 'Подбор'"), 
				НСтр("ru = 'Для основного средства можно выбрать только одно РНПТ'"));
			ИначеЕсли КоличествоПодобрано < Количество Тогда
				ЕстьОшибки = Истина;
				ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
				"Список", 
				"Корректность",,,
				НСтр("ru = 'Подбор'"), 
				НСтр("ru = 'Для основного средства можно выбрать только одно РНПТ'"));
			КонецЕсли;
		КонецЕсли;
		НомерСтроки = 1;
		Для Каждого СтрокаТаблицы Из Подбор Цикл
			Префикс = "Подбор[%1].";
			Префикс = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			Префикс, Формат(НомерСтроки - 1, "ЧН=0; ЧГ="));
			Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.РНПТ) Тогда
				ЕстьОшибки = Истина;
				ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, НСтр("ru = 'РНПТ'"),
				НомерСтроки, НСтр("ru = 'Подбор'"));
				Поле = Префикс + "РНПТ";
				ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, Поле,, Отказ);
			КонецЕсли;
			Если ЭтоСоставноеОС И НЕ ЗначениеЗаполнено(СтрокаТаблицы.Номенклатура) Тогда
				ЕстьОшибки = Истина;
				ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, НСтр("ru = 'Номенклатура'"),
				НомерСтроки, НСтр("ru = 'Подбор'"));
				Поле = Префикс + "Номенклатура";
				ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, Поле,, Отказ);
			КонецЕсли;
			Если  НЕ ЗначениеЗаполнено(СтрокаТаблицы.СтранаПроисхождения) Тогда
				ЕстьОшибки = Истина;
				ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, НСтр("ru = 'Страна происхождения'"),
				НомерСтроки, НСтр("ru = 'Подбор'"));
				Поле = Префикс + "СтранаПроисхождения";
				ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, Поле,, Отказ);
			КонецЕсли;
			Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.Количество) Тогда
				ЕстьОшибки = Истина;
				ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, НСтр("ru = 'Количество'"),
				НомерСтроки, НСтр("ru = 'Подбор'"));
				Поле = Префикс + "Количество";
				ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, Поле,, Отказ);
			КонецЕсли;
			Если РазныеЕдиницыИзмерения
				И НЕ ЗначениеЗаполнено(СтрокаТаблицы.КоличествоПрослеживаемости) Тогда
				ЕстьОшибки = Истина;
				ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, НСтр("ru = 'Количество прослеживаемости'"),
				НомерСтроки, НСтр("ru = 'Подбор'"));
				Поле = Префикс + "КоличествоПрослеживаемости";
				ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, Поле,, Отказ);
			КонецЕсли;
			НомерСтроки = НомерСтроки + 1;
		КонецЦикла;
		
		Если ЕстьОшибки Тогда
			Если ПеренестиВДокумент Тогда
				ПеренестиВДокумент = Ложь;
				ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,"Подбор",,Отказ);
			КонецЕсли;
		Иначе
			Если Не ПеренестиВДокумент Тогда
				Отказ = Истина;
				ТекстВопроса = НСтр("ru = 'Подобранные РНПТ не перенесены в документ.
				|
				|Перенести?'");
				Оповещение = Новый ОписаниеОповещения("ВопросПеренестиВДокументЗавершение", ЭтотОбъект);
				ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВозврата = ПриЗакрытииНаСервере();
	
	Если ПеренестиВДокумент Тогда
		ОповеститьОВыборе(СтруктураВозврата);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПриЗакрытииНаСервере()
	
	СтруктураВозврата = Новый Структура();
	
	Если ПеренестиВДокумент Тогда
		АдресТаблицыРНПТВХранилище = ПоместитьРНПТВХранилище();
		СтруктураВозврата.Вставить("АдресТаблицыРНПТВХранилище", АдресТаблицыРНПТВХранилище);
	КонецЕсли;
	
	Возврат СтруктураВозврата;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОстатки

&НаКлиенте
Процедура ОстаткиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбработатьПодборРНПТ();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПодбор

&НаКлиенте
Процедура ПодборПослеУдаления(Элемент)
	КоличествоПодобрано = Подбор.Итог("Количество");
КонецПроцедуры

&НаКлиенте
Процедура ПодборНоменклатураПриИзменении(Элемент)

	ТекущиеДанные = Элементы.Подбор.ТекущиеДанные;
	ПрослеживаемыйТовар = ПрослеживаемостьФормыВызовСервера.ПолучитьПризнакПрослеживаемости(ТекущиеДанные.Номенклатура);
	Если Не ПрослеживаемыйТовар Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
				Нстр("ru='В качестве номенклатуры может быть указана только прослеживаемая номенклатура'"));
		ТекущиеДанные.Номенклатура = ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка");
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВДокумент(Команда)
	
	ПеренестиВДокумент = НЕ ЭтаФорма.ТолькоПросмотр;
	Закрыть(КодВозвратаДиалога.OK);

КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Модифицированность = Ложь;
	ПеренестиВДокумент = Ложь;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаВыбрать(Команда)
	
	ОбработатьПодборРНПТ();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция КоличествоПрослеживаемости(ОстатокВУчете, ОстатокВПрослеживаемости, ПодобранноеКоличество)
	
	МассивКоэффициентов = Новый Массив;
	МассивКоэффициентов.Добавить(ОстатокВУчете - ПодобранноеКоличество);
	МассивКоэффициентов.Добавить(ПодобранноеКоличество);
	МассивСумм = ОбщегоНазначения.РаспределитьСуммуПропорциональноКоэффициентам(
		ОстатокВПрослеживаемости, МассивКоэффициентов, 11);
	
	Если Не ЗначениеЗаполнено(МассивСумм) Тогда
		Возврат 0;
	Иначе
		Возврат МассивСумм[1];
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ПоместитьРНПТВХранилище()
	
	Для Каждого СтрокаРНПТ Из Подбор Цикл
		Если НЕ РазныеЕдиницыИзмерения Тогда
			СтрокаРНПТ.КоличествоПрослеживаемости = СтрокаРНПТ.Количество;
		КонецЕсли;
	КонецЦикла;
	
	ТаблицаРНПТ = Подбор.Выгрузить();
	АдресТаблицыРНПТВХранилище = ПоместитьВоВременноеХранилище(ТаблицаРНПТ, УникальныйИдентификатор);
	
	Возврат АдресТаблицыРНПТВХранилище;
	
КонецФункции

&НаСервере
Процедура УстановитьЗаголовкиКолонок(СвойстваНоменклатуры)
	
	ТекстЗаголовкаКоличество = НСтр("ru = 'Количество'");
	ТекстЗаголовкаКоличествоПрослеживаемости = НСтр("ru = 'Количество прослеживаемости'");
	Если РазныеЕдиницыИзмерения Тогда
		ТекстЗаголовкаКоличество = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 (%2)'"),
		ТекстЗаголовкаКоличество,
		СвойстваНоменклатуры.ЕдиницаИзмерения);
		ТекстЗаголовкаКоличествоПрослеживаемости = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 (%2)'"),
		ТекстЗаголовкаКоличествоПрослеживаемости,
		СвойстваНоменклатуры.КодТНВЭДЕдиницаИзмерения);
	КонецЕсли;
	Элементы.ОстаткиКоличество.Заголовок = ТекстЗаголовкаКоличество;
	Элементы.ПодборКоличество.Заголовок  = ТекстЗаголовкаКоличество;
	Элементы.ОстаткиКоличествоПрослеживаемости.Заголовок  = ТекстЗаголовкаКоличествоПрослеживаемости;
	Элементы.ПодборКоличествоПрослеживаемости.Заголовок   = ТекстЗаголовкаКоличествоПрослеживаемости;

КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// КоличествоПрослеживаемости в остатках
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ОстаткиКоличествоПрослеживаемости");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"РазныеЕдиницыИзмерения", ВидСравненияКомпоновкиДанных.Равно, Ложь);
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	// КоличествоПрослеживаемости в подборе
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ПодборКоличествоПрослеживаемости");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"РазныеЕдиницыИзмерения", ВидСравненияКомпоновкиДанных.Равно, Ложь);
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПеренестиВДокументЗавершение(ОтветНаВопрос, ДополнительныеПараметры) Экспорт
	
	Если ОтветНаВопрос = КодВозвратаДиалога.Да Тогда
		ПеренестиВДокумент = Истина;
		Закрыть();
	ИначеЕсли ОтветНаВопрос = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		ПеренестиВДокумент = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ТекстЗапросаПринятиеКУчетуОСОбъектСтроительства()
	
	Возврат
	"ВЫБРАТЬ
	|	ПрослеживаемыеОСОстатки.СтранаПроисхождения КАК СтранаПроисхождения,
	|	ПрослеживаемыеОСОстатки.Организация КАК Организация,
	|	ПрослеживаемыеОСОстатки.РНПТ КАК РНПТ,
	|	ПрослеживаемыеОСОстатки.Комплектующие КАК Номенклатура,
	|	ПрослеживаемыеОСОстатки.КоличествоОстаток КАК Количество,
	|	ПрослеживаемыеОСОстатки.КоличествоПрослеживаемостиОстаток КАК КоличествоПрослеживаемости
	|ИЗ
	|	РегистрНакопления.ПрослеживаемыеОсновныеСредства.Остатки(
	|			&Период,
	|			Организация = &Организация
	|				И ОсновноеСредство = &ОбъектСтроительства) КАК ПрослеживаемыеОСОстатки
	|ГДЕ
	|	ПрослеживаемыеОСОстатки.КоличествоОстаток > 0
	|
	|СГРУППИРОВАТЬ ПО
	|	ПрослеживаемыеОСОстатки.Организация,
	|	ПрослеживаемыеОСОстатки.СтранаПроисхождения,
	|	ПрослеживаемыеОСОстатки.РНПТ,
	|	ПрослеживаемыеОСОстатки.Комплектующие,
	|	ПрослеживаемыеОСОстатки.КоличествоОстаток,
	|	ПрослеживаемыеОСОстатки.КоличествоПрослеживаемостиОстаток";
	
КонецФункции

&НаСервере
Функция ТекстЗапросаПринятиеКУчетуОСОборудование()
	
	Возврат
	"ВЫБРАТЬ
	|	ПрослеживаемыеТоварыОстатки.СтранаПроисхождения КАК СтранаПроисхождения,
	|	ПрослеживаемыеТоварыОстатки.Организация КАК Организация,
	|	ПрослеживаемыеТоварыОстатки.РНПТ КАК РНПТ,
	|	СУММА(ПрослеживаемыеТоварыОстатки.КоличествоОстаток) КАК Количество,
	|	СУММА(ПрослеживаемыеТоварыОстатки.КоличествоПрослеживаемостиОстаток) КАК КоличествоПрослеживаемости,
	|	ПрослеживаемыеТоварыОстатки.Номенклатура КАК Номенклатура
	|ИЗ
	|	РегистрНакопления.ПрослеживаемыеТовары.Остатки(
	|			&Период,
	|			Организация = &Организация
	|				И Номенклатура = &Номенклатура
	|				И Комиссионер = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	|				И Комитент = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	|				И ВидЗапасов = ЗНАЧЕНИЕ(Перечисление.ВидыЗапасовПрослеживаемыхТоваров.ПустаяСсылка)) КАК ПрослеживаемыеТоварыОстатки
	|ГДЕ
	|	ПрослеживаемыеТоварыОстатки.КоличествоОстаток > 0
	|
	|СГРУППИРОВАТЬ ПО
	|	ПрослеживаемыеТоварыОстатки.Организация,
	|	ПрослеживаемыеТоварыОстатки.СтранаПроисхождения,
	|	ПрослеживаемыеТоварыОстатки.РНПТ,
	|	ПрослеживаемыеТоварыОстатки.Номенклатура";
	
КонецФункции

&НаКлиенте
Процедура ОбработатьПодборРНПТ()
	
	СтрокаПодбора = Элементы.Остатки.ТекущиеДанные;
	
	Если СтрокаПодбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	Если СтрокаПодбора.Количество + КоличествоПодобрано > Количество И Не ЭтоСоставноеОС Тогда
		
		КоличествоСкорректированное = Количество - КоличествоПодобрано;
		
		Если КоличествоСкорректированное = 0 Тогда
			ТекстСообщения = НСтр("ru='Все РНПТ подобраны.'");
			ПоказатьПредупреждение(, ТекстСообщения);
			Возврат;
		КонецЕсли;
		
		Если ЭтоСоставноеОС Тогда
			СтрокиСРНПТ = Подбор.НайтиСтроки(Новый Структура("РНПТ, СтранаПроисхождения, Номенклатура",
				СтрокаПодбора.РНПТ, СтрокаПодбора.СтранаПроисхождения, СтрокаПодбора.Номенклатура));
		Иначе
			СтрокиСРНПТ = Подбор.НайтиСтроки(Новый Структура("РНПТ, СтранаПроисхождения",
				СтрокаПодбора.РНПТ, СтрокаПодбора.СтранаПроисхождения));
		КонецЕсли;
			
		Если СтрокиСРНПТ.Количество() = 0 Тогда
			НоваяСтрока = Подбор.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаПодбора);
			НоваяСтрока.Количество = КоличествоСкорректированное;
			НоваяСтрока.КоличествоПрослеживаемости = КоличествоПрослеживаемости(
			СтрокаПодбора.Количество, СтрокаПодбора.КоличествоПрослеживаемости, КоличествоСкорректированное);
			
		Иначе
			СтрокиСРНПТ[0].Количество = СтрокиСРНПТ[0].Количество + КоличествоСкорректированное;
			СтрокиСРНПТ[0].КоличествоПрослеживаемости = СтрокиСРНПТ[0].КоличествоПрослеживаемости + КоличествоПрослеживаемости(
			СтрокаПодбора.Количество, СтрокаПодбора.КоличествоПрослеживаемости, КоличествоСкорректированное);
			
		КонецЕсли;
		
	Иначе
		
		Если ЭтоСоставноеОС Тогда
			СтрокиСРНПТ = Подбор.НайтиСтроки(Новый Структура("РНПТ, СтранаПроисхождения, Номенклатура",
				СтрокаПодбора.РНПТ, СтрокаПодбора.СтранаПроисхождения, СтрокаПодбора.Номенклатура));
		Иначе
			СтрокиСРНПТ = Подбор.НайтиСтроки(Новый Структура("РНПТ, СтранаПроисхождения",
				СтрокаПодбора.РНПТ, СтрокаПодбора.СтранаПроисхождения));
		КонецЕсли;
		
		Если СтрокиСРНПТ.Количество() = 0 Тогда
			НоваяСтрока = Подбор.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаПодбора);
			
		Иначе
			СтрокиСРНПТ[0].Количество = СтрокиСРНПТ[0].Количество + СтрокаПодбора.Количество;
			СтрокиСРНПТ[0].КоличествоПрослеживаемости = СтрокиСРНПТ[0].КоличествоПрослеживаемости + СтрокаПодбора.КоличествоПрослеживаемости;
		КонецЕсли;
		
	КонецЕсли;
	
	КоличествоПодобрано = Подбор.Итог("Количество");
	
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти
