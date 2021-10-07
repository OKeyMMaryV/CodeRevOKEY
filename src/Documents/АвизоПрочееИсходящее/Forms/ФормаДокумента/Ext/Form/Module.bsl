﻿#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ОбщегоНазначенияБПКлиент.ОбработкаОповещенияФормыДокумента(ЭтаФорма, Объект.Ссылка, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
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

	ПодготовитьФормуНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	БухгалтерскийУчетКлиентСервер.УстановитьНачальныеСвойстваСубконтоТаблицы(
		Объект.ДанныеБух,
		ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
	
	Для каждого СтрокаТабЧасти Из Объект.ДанныеБух Цикл
		ЗаполнитьДобавленныеКолонкиСтрокиТабличнойЧасти(СтрокаТабЧасти);
	КонецЦикла;
	
	УстановитьСостояниеДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)

	Если НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДатаДокумента) Тогда
		// Изменение времени не влияет на поведение документа.
		ТекущаяДатаДокумента = Объект.Дата;
		Возврат;
	КонецЕсли;

	// Общие проверки условий по датам.
	ТребуетсяВызовСервера = ОбщегоНазначенияБПКлиент.ТребуетсяВызовСервераПриИзмененииДатыДокумента(Объект.Дата, 
		ТекущаяДатаДокумента);
	
	// Если определили, что изменение даты может повлиять на какие-либо параметры, 
	// то передаем обработку на сервер.
	Если ТребуетсяВызовСервера Тогда
		ДатаПриИзмененииНаСервере();
	КонецЕсли;
	
	// Запомним новую дату документа.
	ТекущаяДатаДокумента = Объект.Дата;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)

	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПолучательПриИзменении(Элемент)
	
	ЗагрузитьСписокВыбораПодразделений(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДанныеБух

&НаКлиенте
Процедура ДанныеБухПередНачаломИзменения(Элемент, Отказ)
	
	ТекущиеДанные = Элементы.ДанныеБух.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	БухгалтерскийУчетКлиентСервер.УстановитьНачальныеСвойстваСубконтоСтроки(
		ЭтотОбъект,
		ТекущиеДанные,
		ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеБухПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		ЗаполнитьНадписиВПроводке(Элементы.ДанныеБух.ТекущиеДанные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеБухСчетУчетаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ДанныеБух.ТекущиеДанные;
	
	БухгалтерскийУчетКлиентСервер.УстановитьСвойстваСубконтоСтрокиПриИзмененииСчета(
		ЭтотОбъект,
		ТекущиеДанные,
		ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
	
	ЗаполнитьДобавленныеКолонкиСтрокиТабличнойЧасти(ТекущиеДанные);
	
	ОбнулитьНедоступныеЗначенияСтрокиТабличнойЧасти(ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеБухСубконто1ПриИзменении(Элемент)
	
	ПриИзмененииСубконто(1);
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеБухСубконто1НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	НачалоВыбораСубконто(Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеБухСубконто2ПриИзменении(Элемент)
	
	ПриИзмененииСубконто(2);
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеБухСубконто2НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	НачалоВыбораСубконто(Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеБухСубконто3ПриИзменении(Элемент)
	
	ПриИзмененииСубконто(3);
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеБухСубконто3НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	НачалоВыбораСубконто(Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеБухВалютаПриИзменении(Элемент)
	
	ОбработатьИзменениеВалютыВалютнойСуммы();
	
КонецПроцедуры

 &НаКлиенте
Процедура ДанныеБухВалютнаяСуммаПриИзменении(Элемент)
	
 	ОбработатьИзменениеВалютыВалютнойСуммы();
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеБухСуммаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ДанныеБух.ТекущиеДанные;
	Если ТекущиеДанные.Сумма <> 0 Тогда
		ТекущиеДанные.СуммаКТ = 0;
	КонецЕсли;

	РасчетСуммыНУ();
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеБухСуммаКТПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ДанныеБух.ТекущиеДанные;
	Если ТекущиеДанные.СуммаКТ <> 0 Тогда
		ТекущиеДанные.Сумма = 0;
	КонецЕсли;
	
	РасчетСуммыНУ();
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеБухСуммаПРПриИзменении(Элемент)

	РасчетСуммыНУ();
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеБухСуммаВРПриИзменении(Элемент)
	
	РасчетСуммыНУ();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

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

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();


	////////////////////
	// Субконто
	
	Для Сч = 1 По 3 Цикл

		// Не показываем субконто совсем, если его нет на счете, чтобы не занимать строку на экране,
		// кроме первого субконто, которое показывается всегда, т.к. на счете может не быть учета по 
		// подразделениям и строка с субконто1 будет единственной видимой строкой в колонке.

		ЭлементУО = УсловноеОформление.Элементы.Добавить();

		КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ДанныеБухСубконто" + Сч);

		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
			"Объект.ДанныеБух.Субконто" + Сч + "Доступность", ВидСравненияКомпоновкиДанных.Равно, Ложь);

		Если Сч = 1 Тогда
			ЭлементУО.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
		Иначе
			ЭлементУО.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
		КонецЕсли;
		

		// Пустое субконто в виде <...>

		ЭлементУО = УсловноеОформление.Элементы.Добавить();

		КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ДанныеБухСубконто" + Сч);

		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
			"Объект.ДанныеБух.Субконто" + Сч + "Доступность", ВидСравненияКомпоновкиДанных.Равно, Истина);

		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
			"Объект.ДанныеБух.Субконто" + Сч, ВидСравненияКомпоновкиДанных.НеЗаполнено);

		ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НеЗаполненноеСубконто);

		ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<...>'"));
		
	КонецЦикла;


	////////////////////
	// Подразделение

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ДанныеБухПодразделение");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.ДанныеБух.ПодразделениеДоступность", ВидСравненияКомпоновкиДанных.Равно, Ложь);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);


	// ДанныеБухПодразделение

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ДанныеБухПодразделение");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.ДанныеБух.ПодразделениеДоступность", ВидСравненияКомпоновкиДанных.Равно, Истина);

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.ДанныеБух.Подразделение", ВидСравненияКомпоновкиДанных.НеЗаполнено);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НеЗаполненноеСубконто);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<...>'"));


	// ДанныеБухСуммаНУ, ДанныеБухСуммаПР, ДанныеБухСуммаВР

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ДанныеБухСуммаНУ");
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ДанныеБухСуммаПР");
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ДанныеБухСуммаВР");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.ДанныеБух.СчетУчетаНалоговыйУчет", ВидСравненияКомпоновкиДанных.Равно, Ложь);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);


	// ДанныеБухКоличество

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ДанныеБухКоличество");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.ДанныеБух.СчетУчетаКоличественный", ВидСравненияКомпоновкиДанных.Равно, Ложь);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);


	// ДанныеБухВалюта, ДанныеБухВалютнаяСумма

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ДанныеБухВалюта");
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ДанныеБухВалютнаяСумма");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.ДанныеБух.СчетУчетаВалютный", ВидСравненияКомпоновкиДанных.Равно, Ложь);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);


	// ДанныеБухСумма

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ДанныеБухСумма");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.ДанныеБух.СуммаДоступность", ВидСравненияКомпоновкиДанных.Равно, Ложь);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);


	// ДанныеБухСуммаКТ

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ДанныеБухСуммаКТ");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.ДанныеБух.СуммаКтДоступность", ВидСравненияКомпоновкиДанных.Равно, Ложь);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);


КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		УстановитьФункциональныеОпцииФормы();
		ЗаполнениеДокументов.ПриИзмененииЗначенияОрганизации(Объект, Пользователи.ТекущийПользователь());
	КонецЕсли;
	
	ЗагрузитьСписокВыбораПодразделений(Истина);
	
	БухгалтерскийУчетКлиентСервер.УстановитьСвойстваСубконтоТаблицыПриИзмененииОрганизации(
		Объект.ДанныеБух,
		ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
	
КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииНаСервере()
	
	УстановитьФункциональныеОпцииФормы();

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьИзменениеВалютыВалютнойСуммы()
	
	ТекущиеДанные = Элементы.ДанныеБух.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Сумма = ПересчетСуммыПоКурсу(ТекущиеДанные.ВалютнаяСумма, ТекущиеДанные.Валюта, Объект.Дата);
	Если ТекущиеДанные.Сумма <> 0 Тогда
		ТекущиеДанные.Сумма = Сумма;
	ИначеЕсли ТекущиеДанные.СуммаКТ <> 0 Тогда
		ТекущиеДанные.СуммаКт = Сумма;
	Иначе
		ТекущиеДанные.Сумма = Сумма;
	КонецЕсли;
	
	РасчетСуммыНУ();
	
КонецПроцедуры 

&НаСервере
Процедура ПодготовитьФормуНаСервере()

	ТекущаяДатаДокумента			= Объект.Дата;

	ВалютаРегламентированногоУчета 	= ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	УстановитьФункциональныеОпцииФормы();
	
	УстановитьСостояниеДокумента();

	ЗагрузитьСписокВыбораПодразделений(Истина);
	
	БухгалтерскийУчетКлиентСервер.УстановитьНачальныеСвойстваСубконтоТаблицы(
		Объект.ДанныеБух,
		ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
	
	Для каждого СтрокаТабЧасти Из Объект.ДанныеБух Цикл
		ЗаполнитьДобавленныеКолонкиСтрокиТабличнойЧасти(СтрокаТабЧасти);
	КонецЦикла;   	

КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()

	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПересчетСуммыПоКурсу(Знач ВалютнаяСумма, Знач Валюта, Знач Дата)

	СтруктураКурса = РаботаСКурсамиВалют.ПолучитьКурсВалюты(Валюта, Дата);

	Сумма = ?(СтруктураКурса.Кратность = 0, 0, Окр(ВалютнаяСумма * СтруктураКурса.Курс / СтруктураКурса.Кратность, 2));
	Возврат Сумма;

КонецФункции

&НаКлиенте
Процедура ОбнулитьНедоступныеЗначенияСтрокиТабличнойЧасти(ПараметрыСтроки)

	Если НЕ ПараметрыСтроки.СуммаДоступность Тогда
		ПараметрыСтроки["Сумма"] = 0;
	КонецЕсли;		
	Если НЕ ПараметрыСтроки.СуммаКтДоступность Тогда
		ПараметрыСтроки["СуммаКт"] = 0;
	КонецЕсли;		
	Если НЕ ПараметрыСтроки.СчетУчетаВалютный Тогда
		ПараметрыСтроки["Валюта"]        = Неопределено;
		ПараметрыСтроки["ВалютнаяСумма"] = 0;
	КонецЕсли;
	Если НЕ ПараметрыСтроки.СчетУчетаНалоговыйУчет Тогда
		ПараметрыСтроки["СуммаНУ"] = 0;
		ПараметрыСтроки["СуммаПР"] = 0;
		ПараметрыСтроки["СуммаВР"] = 0;
	КонецЕсли;
	Если НЕ ПараметрыСтроки.СчетУчетаКоличественный Тогда
		ПараметрыСтроки["Количество"] = 0;
	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьДобавленныеКолонкиСтрокиТабличнойЧасти(ПараметрыСтроки)

	ПараметрыСтроки.СуммаДоступность   = ЗначениеЗаполнено(ПараметрыСтроки["СчетУчета"]);
	ПараметрыСтроки.СуммаКтДоступность = ЗначениеЗаполнено(ПараметрыСтроки["СчетУчета"]);
	
	ЗаполнитьНадписиВПроводке(ПараметрыСтроки);
	
КонецПроцедуры
			
&НаКлиенте
Процедура РасчетСуммыНУ()

	ТекущиеДанные = Элементы.ДанныеБух.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если ТекущиеДанные.СчетУчетаНалоговыйУчет Тогда
		Если ТекущиеДанные.Сумма <> 0 Тогда
	        ТекущиеДанные.СуммаНУ = ТекущиеДанные.Сумма - ТекущиеДанные.СуммаПР - ТекущиеДанные.СуммаВР;
		ИначеЕсли ТекущиеДанные.СуммаКТ <> 0 Тогда
	        ТекущиеДанные.СуммаНУ = ТекущиеДанные.СуммаКТ - ТекущиеДанные.СуммаПР - ТекущиеДанные.СуммаВР;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьНадписиВПроводке(Проводка)
	
	Проводка.НадписьНУ  = НСтр("ru = 'НУ'");
	Проводка.НадписьПР 	= НСтр("ru = 'ПР'");
	Проводка.НадписьВР	= НСтр("ru = 'ВР'");
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСписокВыбораПодразделений(ОтборПоОрганизации = Истина)
	
	УправляющийРеквизит = ?(ОтборПоОрганизации, Объект.Организация, Объект.ОрганизацияПолучатель);
	УправляющийЭлемент	= ?(ОтборПоОрганизации,Элементы.Организация, Элементы.ОрганизацияПолучатель);
	
	УправляемыйРеквизит = ?(ОтборПоОрганизации, Объект.ОрганизацияПолучатель, Объект.Организация);
	УправляемыйЭлемент	= ?(ОтборПоОрганизации, Элементы.ОрганизацияПолучатель, Элементы.Организация);
	
	Если ЗначениеЗаполнено(УправляющийРеквизит) Тогда 
		
		СписокВыбораПодразделений = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьСписокОбособленныхПодразделений(УправляющийРеквизит).ВыгрузитьЗначения();	
		
		УправляемыйЭлемент.РежимВыбораИзСписка = Истина;
		УправляемыйЭлемент.СписокВыбора.ЗагрузитьЗначения(СписокВыбораПодразделений);
			
		Если УправляемыйЭлемент.СписокВыбора.НайтиПоЗначению(УправляющийРеквизит) = Неопределено Тогда
			
			УправляемыйРеквизит = Справочники.Организации.ПустаяСсылка();
			
		ИначеЕсли ЗначениеЗаполнено(УправляемыйРеквизит) Тогда
			
			УправляющийЭлемент.РежимВыбораИзСписка = Истина;
			УправляющийЭлемент.СписокВыбора.ЗагрузитьЗначения(СписокВыбораПодразделений);

		КонецЕсли;                                            	
		
	Иначе
		
		УправляемыйЭлемент.РежимВыбораИзСписка = Ложь;
		УправляемыйЭлемент.СписокВыбора.Очистить();
		
		Если Не ЗначениеЗаполнено(УправляемыйРеквизит) Тогда 
			
			УправляющийЭлемент.РежимВыбораИзСписка = Ложь;
			УправляющийЭлемент.СписокВыбора.Очистить();
			
		КонецЕсли;
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииСубконто(НомерСубконто)
	
	БухгалтерскийУчетКлиентСервер.УстановитьСвойстваСубконтоСтрокиПриИзмененииСубконто(
		ЭтотОбъект, 
		Элементы.ДанныеБух.ТекущиеДанные,
		НомерСубконто, 
		ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура НачалоВыбораСубконто(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДанныеОбъекта = БухгалтерскийУчетКлиентСервер.ДанныеУстановкиПараметровСубконто(
		Элементы.ДанныеБух.ТекущиеДанные,
		ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
	
	ОбщегоНазначенияБПКлиент.НачалоВыбораЗначенияСубконто(ЭтотОбъект, Элемент, СтандартнаяОбработка, ДанныеОбъекта);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПараметрыУстановкиСвойствСубконто(Форма)

	Результат = БухгалтерскийУчетКлиентСервер.ПараметрыУстановкиСвойствСубконтоПоШаблону(
		"ДанныеБухСубконто", "ДанныеБухПодразделение", "Субконто", "Подразделение", "СчетУчета");
		
	Результат.ПоляОбъекта.Вставить("Количественный", "СчетУчетаКоличественный");
	Результат.ПоляОбъекта.Вставить("Валютный",       "СчетУчетаВалютный");
	Результат.ПоляОбъекта.Вставить("НалоговыйУчет",  "СчетУчетаНалоговыйУчет");
		
	Результат.ДопРеквизиты.Вставить("Организация", Форма.Объект.Организация);
	Результат.СкрыватьСубконто = Ложь;
	
	Возврат Результат;

КонецФункции

#КонецОбласти


