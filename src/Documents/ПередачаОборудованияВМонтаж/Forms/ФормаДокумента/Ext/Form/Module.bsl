#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если Параметры.Ключ.Пустая() Тогда
		УстановитьФункциональныеОпцииФормы();
		УстановитьСостояниеДокумента();
	КонецЕсли;	
	
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-10-14 (#4405)
	Для Каждого Строка Из Объект.Оборудование Цикл
		ПрослеживаемостьФормыКлиентСерверБП.ЗаполнитьПредставлениеРНПТ(ЭтаФорма, Строка, Ложь);
	КонецЦикла;
	Элементы.ГруппаПрослеживаемоеОборудование.Видимость = ВедетсяУчетПрослеживаемыхТоваров;
	УстановитьУсловноеОформление();
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-10-14 (#4405)
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)

	Если ИсточникВыбора.ИмяФормы = "Обработка.ПодборНоменклатуры.Форма.Форма" Тогда
		ОбработкаВыбораПодборСервер(ВыбранноеЗначение);
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-10-14 (#4405)
	ИначеЕсли ИсточникВыбора.ИмяФормы = "Справочник.НомераГТД.Форма.ФормаПодбораРНПТ" Тогда
		ОбработкаВыбораРНПТНаКлиенте(ВыбранноеЗначение, ИсточникВыбора.ИмяТаблицы);
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-10-14 (#4405)
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	ОбщегоНазначенияБПКлиент.ОбработкаОповещенияФормыДокумента(ЭтаФорма, Объект.Ссылка, ИмяСобытия, Параметр, Источник);
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	УстановитьФункциональныеОпцииФормы();
	УстановитьСостояниеДокумента();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.РежимЗаписи = ПредопределенноеЗначение("РежимЗаписиДокумента.Проведение") Тогда
		КлючеваяОперация = "ПроведениеПередачаОборудованияВМонтаж";
		ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	УстановитьСостояниеДокумента();
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-10-14 (#4405)
	Для Каждого Строка Из Объект.Оборудование Цикл
		ПрослеживаемостьФормыКлиентСерверБП.ЗаполнитьПредставлениеРНПТ(ЭтаФорма, Строка, Ложь);
	КонецЦикла;
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-10-14 (#4405)
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-10-14 (#4405)
&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры
//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-10-14 (#4405)
#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	УстановитьФункциональныеОпцииФормы();
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-10-14 (#4405)
	ДатаПриИзмененииНаСервере();
	Элементы.ГруппаПрослеживаемоеОборудование.Видимость = ВедетсяУчетПрослеживаемыхТоваров;
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-10-14 (#4405)
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)

	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		ОрганизацияПриИзмененииНаСервере();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СкладПриИзменении(Элемент)

	Если ЗначениеЗаполнено(Объект.Склад) Тогда
		СкладПриИзмененииНаСервере();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбъектСтроительстваПриИзменении(Элемент)

	Если ЗначениеЗаполнено(Объект.ОбъектСтроительства) Тогда
		СчетаУчета = ПолучитьСчетаУчетаОбъектаСтроительства(Объект.Организация, Объект.ОбъектСтроительства);
		Объект.СчетУчетаОбъектаСтроительства = СчетаУчета.СчетУчета;
		Объект.СпособУчетаНДС = СчетаУчета.СпособУчетаНДС;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОборудование

&НаКлиенте
Процедура ОборудованиеНоменклатураПриИзменении(Элемент)

	ТекущиеДанные = Элементы.Оборудование.ТекущиеДанные;
	
	ДанныеСтрокиТаблицы = Новый Структура(
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-10-14 (#4405)
		//"Номенклатура, Коэффициент, СчетУчета");
		"Номенклатура, Коэффициент, СчетУчета, ПрослеживаемыйТовар, СтранаПроисхождения");
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-10-14 (#4405)
	ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, ТекущиеДанные);
	
	ДанныеОбъекта = Новый Структура(
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-10-14 (#4405)
		//"Дата, Организация, Склад");
		"Дата, Организация, Склад, ВедетсяУчетПрослеживаемыхТоваров");
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-10-14 (#4405)
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-10-26 (#4405)
	ДанныеОбъекта.ВедетсяУчетПрослеживаемыхТоваров = ВедетсяУчетПрослеживаемыхТоваров;
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-10-26 (#4405)
	
	ОборудованиеНоменклатураПриИзмененииНаСервере(ДанныеСтрокиТаблицы, ДанныеОбъекта);
	
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, ДанныеСтрокиТаблицы);

	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-10-14 (#4405)
	Если ТекущиеДанные <> Неопределено Тогда
		// Необходимо очистить дополнительные сведения
		НоваяСтрока = ТаблицаУдаленныхСтрок.Добавить();
		НоваяСтрока.ИдентификаторСтроки = ТекущиеДанные.ИдентификаторСтроки;
	КонецЕсли;
	ПодключитьОбработчикОжидания("Подключаемый_УдалитьСвязанныеЗаписи", 0.1, Истина);
	ПрослеживаемостьФормыКлиентСерверБП.ЗаполнитьПредставлениеРНПТ(ЭтаФорма, ТекущиеДанные, Ложь);
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-10-14 (#4405)
КонецПроцедуры

//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-10-14 (#4405)
&НаКлиенте
Процедура ОборудованиеСтранаПроисхожденияПриИзменении(Элемент)
	ТекущиеДанные = Элементы.Оборудование.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		// Необходимо очистить дополнительные сведения
		НоваяСтрока = ТаблицаУдаленныхСтрок.Добавить();
		НоваяСтрока.ИдентификаторСтроки = ТекущиеДанные.ИдентификаторСтроки;
		ПрослеживаемостьФормыКлиентСерверБП.ЗаполнитьПредставлениеРНПТ(ЭтаФорма, ТекущиеДанные, Ложь);
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("Подключаемый_УдалитьСвязанныеЗаписи", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОборудованиеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Поле.Имя = "ОборудованиеРНПТ" Тогда
		ТекущиеДанные = Элементы.Оборудование.ТекущиеДанные;
		СтандартнаяОбработка = Ложь;
		Если ТекущиеДанные.ПрослеживаемыйТовар Тогда
			ПрослеживаемостьФормыКлиентБП.ОткрытьФормуПодбораРНПТ(ЭтаФорма, "Оборудование", Ложь);
		КонецЕсли;
	КонецЕсли;
	
	Если Поле.Имя = "ОборудованиеПрослеживаемыйТовар" Тогда
		ТекущиеДанные = Элементы.Оборудование.ТекущиеДанные;
		Если ТекущиеДанные.ПрослеживаемыйТовар Тогда
			ПрослеживаемостьФормыКлиентБП.ПоказатьПредупреждениеПрослеживаемыйТовар();
		Конецесли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОборудованиеКоличествоПриИзменении(Элемент)
	ТекущиеДанные = Элементы.Оборудование.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		// Необходимо очистить дополнительные сведения
		НоваяСтрока = ТаблицаУдаленныхСтрок.Добавить();
		НоваяСтрока.ИдентификаторСтроки = ТекущиеДанные.ИдентификаторСтроки;
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("Подключаемый_УдалитьСвязанныеЗаписи", 0.1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ОборудованиеПередУдалением(Элемент, Отказ)
	
	ВыделенныеСтроки = Элементы.Оборудование.ВыделенныеСтроки;
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаОборудование Из ВыделенныеСтроки Цикл
		ТекДанные = Объект.Оборудование.НайтиПоИдентификатору(СтрокаОборудование);
		Если ТекДанные <> Неопределено Тогда
			// Необходимо очистить дополнительные сведения
			НоваяСтрока = ТаблицаУдаленныхСтрок.Добавить();
			НоваяСтрока.ИдентификаторСтроки = ТекДанные.ИдентификаторСтроки;
		КонецЕсли;
	КонецЦикла;
	
	ПодключитьОбработчикОжидания("Подключаемый_УдалитьСвязанныеЗаписи", 0.1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ОборудованиеПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если Копирование Тогда
		Элемент.ТекущиеДанные.ИдентификаторСтроки = "";
		ПрослеживаемостьФормыКлиентСерверБП.ЗаполнитьПредставлениеРНПТ(ЭтаФорма, Элемент.ТекущиеДанные, Ложь);
	КонецЕсли;
КонецПроцедуры
//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-10-14 (#4405)
#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодборНоменклатуры(Команда)

	ПараметрыФормы = Новый Структура;

	ДатаРасчетов = ?(НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДата()), Неопределено, Объект.Дата);

	ЗаголовокПодбора = НСтр("ru = 'Подбор номенклатуры в документ %1 (%2)'");
	ПредставлениеТаблицы = НСтр("ru = 'Оборудование'");

	ЗаголовокПодбора = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ЗаголовокПодбора,
		Объект.Ссылка, ПредставлениеТаблицы);

	ПараметрыФормы.Вставить("ДатаРасчетов"  , ДатаРасчетов);
	ПараметрыФормы.Вставить("Склад"         , Объект.Склад);
	ПараметрыФормы.Вставить("Организация"   , Объект.Организация);
	ПараметрыФормы.Вставить("Подразделение" , Объект.ПодразделениеОрганизации);
	ПараметрыФормы.Вставить("Валюта"        , ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета());
	ПараметрыФормы.Вставить("ЕстьЦена"      , Ложь);
	ПараметрыФормы.Вставить("ЕстьКоличество", Истина);
	ПараметрыФормы.Вставить("Заголовок"     , ЗаголовокПодбора);

	СписокПодборов = Новый СписокЗначений();
	СписокПодборов.Добавить("", НСтр("ru = 'По справочнику'"));

	ПараметрыФормы.Вставить("СписокПодборов", СписокПодборов);
	ПараметрыФормы.Вставить("ИмяТаблицы"    , "Оборудование");
	ПараметрыФормы.Вставить("Услуги"        , Ложь);
	ПараметрыФормы.Вставить("ПоказыватьОстатки"  , Истина);

	ОткрытьФорму("Обработка.ПодборНоменклатуры.Форма.Форма", ПараметрыФормы, ЭтаФорма, УникальныйИдентификатор);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()

	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);
	
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-10-14 (#4405)
	ВедетсяУчетПрослеживаемыхТоваров = ПолучитьФункциональнуюОпцию("ВестиУчетПрослеживаемыхТоваров")
		И ПрослеживаемостьБРУ.ВедетсяУчетПрослеживаемыхТоваров(Объект.Дата);
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-10-14 (#4405)
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОборудованиеНоменклатураПриИзмененииНаСервере(СтрокаТаблицы, Знач ДанныеОбъекта)

	СведенияОНоменклатуре = БухгалтерскийУчетПереопределяемый.ПолучитьСведенияОНоменклатуре(
		СтрокаТаблицы.Номенклатура, ДанныеОбъекта);
	Если СведенияОНоменклатуре = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-10-14 (#4405)
	Если ДанныеОбъекта.ВедетсяУчетПрослеживаемыхТоваров Тогда
		СтрокаТаблицы.ПрослеживаемыйТовар = СведенияОНоменклатуре.ПрослеживаемыйТовар;
		СтрокаТаблицы.СтранаПроисхождения = СведенияОНоменклатуре.СтранаПроисхождения;
	Иначе
		СтрокаТаблицы.ПрослеживаемыйТовар = Ложь;
	КонецЕсли;
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-10-14 (#4405)
	Документы.ПередачаОборудованияВМонтаж.ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(
		ДанныеОбъекта, СтрокаТаблицы, "Оборудование", СведенияОНоменклатуре);

КонецПроцедуры

&НаСервере
Процедура ОбработкаВыбораПодборСервер(ВыбранноеЗначение)

	ТаблицаТоваров = ПолучитьИзВременногоХранилища(ВыбранноеЗначение.АдресПодобраннойНоменклатурыВХранилище);
	
	ДанныеОбъекта = Новый Структура("Дата, Организация, Склад");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	
	СоответствиеСчетовУчета = БухгалтерскийУчетПереопределяемый.ПолучитьСчетаУчетаСпискаНоменклатуры(
		ДанныеОбъекта.Организация, ОбщегоНазначения.ВыгрузитьКолонку(ТаблицаТоваров, "Номенклатура", Истина), ДанныеОбъекта.Склад, ДанныеОбъекта.Дата);
	
	Для каждого СтрокаТовара Из ТаблицаТоваров Цикл
		
		СтрокаТабличнойЧасти = Объект.Оборудование.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтрокаТовара);
		
		СчетаУчета = СоответствиеСчетовУчета.Получить(СтрокаТовара.Номенклатура);
		
		//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-10-14 (#4405)
		СведенияОНоменклатуре = БухгалтерскийУчетПереопределяемый.ПолучитьСведенияОНоменклатуре(
		СтрокаТовара.Номенклатура, ДанныеОбъекта);
		
		Если ВедетсяУчетПрослеживаемыхТоваров И СведенияОНоменклатуре <> Неопределено Тогда
			СтрокаТабличнойЧасти.ПрослеживаемыйТовар = СведенияОНоменклатуре.ПрослеживаемыйТовар;
			СтрокаТабличнойЧасти.СтранаПроисхождения = СведенияОНоменклатуре.СтранаПроисхождения;
		Иначе
			СтрокаТабличнойЧасти.ПрослеживаемыйТовар = Ложь;
		КонецЕсли;
		//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-10-14 (#4405)
		Документы.ПередачаОборудованияВМонтаж.ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(
			ДанныеОбъекта, СтрокаТабличнойЧасти, "Оборудование", СчетаУчета);
		
	КонецЦикла;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСчетаУчетаОбъектаСтроительства(Знач Организация, Знач ОбъектСтроительства)

	СчетаУчета = БухгалтерскийУчетПереопределяемый.СчетаУчетаОбъектовСтроительства(Организация, ОбъектСтроительства);
	
	Возврат СчетаУчета;

КонецФункции  

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()

	УстановитьФункциональныеОпцииФормы();
	
	Объект.ПодразделениеОрганизации = ОбщегоНазначенияБПВызовСервера.ПолучитьПодразделение(
		Объект.Организация, Объект.Склад);
	
	ЗаполнитьСчетаУчетаВТабличнойЧастиНаСервере();

КонецПроцедуры

&НаСервере
Процедура СкладПриИзмененииНаСервере()

	Объект.ПодразделениеОрганизации = ОбщегоНазначенияБПВызовСервера.ПолучитьПодразделение(
		Объект.Организация, Объект.Склад);
	
	ЗаполнитьСчетаУчетаВТабличнойЧастиНаСервере();

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСчетаУчетаВТабличнойЧастиНаСервере(ИмяТабличнойЧасти = "")

	Если ПустаяСтрока(ИмяТабличнойЧасти) ИЛИ ИмяТабличнойЧасти = "Оборудование" Тогда
		Документы.ПередачаОборудованияВМонтаж.ЗаполнитьСчетаУчетаВТабличнойЧасти(Объект, "Оборудование");
	КонецЕсли;

КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-10-14 (#4405)
&НаКлиенте
Процедура Подключаемый_УдалитьСвязанныеЗаписи()
	
	УдалитьСвязанныеЗаписиНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораРНПТНаКлиенте(ВыбранноеЗначение, ИмяТаблицы)
	
	СтрокаТабличнойЧасти = Элементы[ИмяТаблицы].ТекущиеДанные;
	
	Если СтрокаТабличнойЧасти <> Неопределено Тогда
		Если Не ЗначениеЗаполнено(СтрокаТабличнойЧасти.ИдентификаторСтроки) Тогда
			СтрокаТабличнойЧасти.ИдентификаторСтроки = Новый УникальныйИдентификатор;
		КонецЕсли;
		ОбработкаВыбораРНПТНаСервере(СтрокаТабличнойЧасти.ИдентификаторСтроки, ВыбранноеЗначение);
		ПрослеживаемостьФормыКлиентСерверБП.ЗаполнитьПредставлениеРНПТ(ЭтаФорма, СтрокаТабличнойЧасти, Ложь);
	КонецЕсли;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаВыбораРНПТНаСервере(ИдентификаторСтроки, ВыбранноеЗначение)
	
	ПрослеживаемостьФормыБП.ОбработкаВыбораРНПТН(ЭтотОбъект, ИдентификаторСтроки, ВыбранноеЗначение);
	
КонецПроцедуры

&НаСервере
Процедура УдалитьСвязанныеЗаписиНаСервере()
	
	Для Каждого СтрокаКлюча Из ТаблицаУдаленныхСтрок Цикл
		СтруктураОтбора = Новый Структура("ИдентификаторСтроки", СтрокаКлюча.ИдентификаторСтроки);
		МассивСтрокСведенияПрослеживаемости = Объект.СведенияПрослеживаемости.НайтиСтроки(СтруктураОтбора);
		Для Каждого СтрокаТЧ Из МассивСтрокСведенияПрослеживаемости Цикл
			Объект.СведенияПрослеживаемости.Удалить(СтрокаТЧ);
		КонецЦикла;
		
		СтрокиОборудование = Объект.Оборудование.НайтиСтроки(СтруктураОтбора);
		Для Каждого Строка Из СтрокиОборудование Цикл
			ПрослеживаемостьФормыКлиентСерверБП.ЗаполнитьПредставлениеРНПТ(ЭтаФорма, Строка, Ложь);
		КонецЦикла;
		
	КонецЦикла;
	
	ТаблицаУдаленныхСтрок.Очистить();
	
КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииНаСервере()
	
	РаботаСНоменклатурой.ОбновитьПризнакПрослеживаемости(Объект.Оборудование, ЭтотОбъект.ВедетсяУчетПрослеживаемыхТоваров);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// ОборудованиеСтранаПроисхождения
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ОборудованиеСтранаПроисхождения");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.Оборудование.ПрослеживаемыйТовар", ВидСравненияКомпоновкиДанных.Равно, Истина);
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.Оборудование.СтранаПроисхождения", ВидСравненияКомпоновкиДанных.НеЗаполнено);
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);
	
	// ОборудованиеРНПТ
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ОборудованиеРНПТ");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.Оборудование.РНПТ", ВидСравненияКомпоновкиДанных.НеЗаполнено, "");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.Оборудование.ПрослеживаемыйТовар", ВидСравненияКомпоновкиДанных.Равно, Истина);
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НедоступныеДанныеЦвет);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='<Авто>'"));
	
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ОборудованиеРНПТ");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.Оборудование.ПрослеживаемыйТовар", ВидСравненияКомпоновкиДанных.Равно, Ложь);
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НедоступныеДанныеЦвет);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='<Не требуется>'"));
	
	// Признак прослеживаемости
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ОборудованиеПрослеживаемыйТовар");
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"ВедетсяУчетПрослеживаемыхТоваров", ВидСравненияКомпоновкиДанных.Равно, Ложь);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
КонецПроцедуры
//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-10-14 (#4405) 
#КонецОбласти