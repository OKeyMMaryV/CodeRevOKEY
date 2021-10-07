﻿#Область ОбработчикиСобытийФормы

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
		
		// создается новый документ
		ЗначенияДляЗаполнения = Новый Структура("ПредыдущийМесяц, Ответственный", 
		"Объект.ПериодРегистрации",
		"Объект.Ответственный");
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		
	КонецЕсли;
	
	ПлательщикНалогаНаПрибыль = УчетнаяПолитика.ПлательщикНалогаНаПрибыль(Объект.Организация, Объект.Дата);
	
	СчетаУчетаРасчетовСПерсоналом = Новый Соответствие;
	
	СчетаУчета = Новый Массив;
	СчетаУчета.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСПерсоналомПоОплатеТруда);
	СчетаУчета.Добавить(ПланыСчетов.Хозрасчетный.РасходыНаОплатуТрудаБудущихПериодов);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Хозрасчетный.Ссылка
	|ИЗ
	|	ПланСчетов.Хозрасчетный КАК Хозрасчетный
	|ГДЕ
	|	Хозрасчетный.Ссылка В ИЕРАРХИИ(&СчетаУчета)";
		
	Запрос.УстановитьПараметр("СчетаУчета",СчетаУчета);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СчетаУчетаРасчетовСПерсоналом.Вставить(Выборка.Ссылка,Истина)
	КонецЦикла;
	
	СчетаУчетаРасчетовСРаботниками = Новый ФиксированноеСоответствие(СчетаУчетаРасчетовСПерсоналом);
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцНачисленияСтрокой");
	
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

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.РежимЗаписи = ПредопределенноеЗначение("РежимЗаписиДокумента.Проведение") Тогда
		КлючеваяОперация = "ПроведениеОтражениеЗарплатыВУчете";
		ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ЗаполнитьДобавленныеКолонкиТаблиц();
	УстановитьСостояниеДокумента();
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	Оповестить("ИзменениеОтраженияЗарплатыВУчете");

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
	ДатаПриИзмененииСервер();
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииСервер();

КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииПриИзменении(Элемент)	
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцНачисленияСтрокой", Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииРегулирование(Элемент, Направление, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцНачисленияСтрокой", Направление, Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);	
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);	
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.ПериодРегистрации", "МесяцНачисленияСтрокой", Модифицированность);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОтражениеВУчете

&НаКлиенте
Процедура ОтражениеВУчетеПередНачаломИзменения(Элемент, Отказ)
	
	СтрокаТаблицы = Элементы.ОтражениеВУчете.ТекущиеДанные;
	БухгалтерскийУчетКлиентСервер.УстановитьНачальныеСвойстваСубконтоСтроки(
		ЭтотОбъект,
		СтрокаТаблицы,
		ПараметрыУстановкиСвойствСубконтоДт(ЭтотОбъект));
	БухгалтерскийУчетКлиентСервер.УстановитьНачальныеСвойстваСубконтоСтроки(
		ЭтотОбъект,
		СтрокаТаблицы,
		ПараметрыУстановкиСвойствСубконтоКт(ЭтотОбъект));

КонецПроцедуры

&НаКлиенте
Процедура ОтражениеВУчетеПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		ЗаполнитьНадписиВПроводке(Элементы.ОтражениеВУчете.ТекущиеДанные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражениеВУчетеСчетДтПриИзменении(Элемент)
	
	БухгалтерскийУчетКлиентСервер.УстановитьСвойстваСубконтоСтрокиПриИзмененииСчета(
		ЭтотОбъект,
		Элементы.ОтражениеВУчете.ТекущиеДанные,
		ПараметрыУстановкиСвойствСубконтоДт(ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражениеВУчетеСубконтоДт1ПриИзменении(Элемент)
	
	ПриИзмененииСубконтоДт(1);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражениеВУчетеСубконтоДт1НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	НачалоВыбораСубконтоДт(Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражениеВУчетеСубконтоДт2ПриИзменении(Элемент)
	
	ПриИзмененииСубконтоДт(2);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражениеВУчетеСубконтоДт2НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	НачалоВыбораСубконтоДт(Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражениеВУчетеСубконтоДт3ПриИзменении(Элемент)
	
	ПриИзмененииСубконтоДт(3);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражениеВУчетеСубконтоДт3НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	НачалоВыбораСубконтоДт(Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражениеВУчетеСчетКтПриИзменении(Элемент)
	
	БухгалтерскийУчетКлиентСервер.УстановитьСвойстваСубконтоСтрокиПриИзмененииСчета(
		ЭтотОбъект,
		Элементы.ОтражениеВУчете.ТекущиеДанные,
		ПараметрыУстановкиСвойствСубконтоКт(ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражениеВУчетеСубконтоКт1ПриИзменении(Элемент)
	
	ПриИзмененииСубконтоКт(1);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражениеВУчетеСубконтоКт1НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	НачалоВыбораСубконтоКт(Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражениеВУчетеСубконтоКт2ПриИзменении(Элемент)
	
	ПриИзмененииСубконтоКт(2);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражениеВУчетеСубконтоКт2НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	НачалоВыбораСубконтоКт(Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражениеВУчетеСубконтоКт3ПриИзменении(Элемент)
	
	ПриИзмененииСубконтоКт(3);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражениеВУчетеСубконтоКт3НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	НачалоВыбораСубконтоКт(Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражениеВУчетеСуммаПриИзменении(Элемент)
		
	Если ПлательщикНалогаНаПрибыль Тогда
		СтрокаТаблицы = Элементы.ОтражениеВУчете.ТекущиеДанные;
		СтрокаТаблицы.СуммаНУ = СтрокаТаблицы.Сумма - СтрокаТаблицы.СуммаПР - СтрокаТаблицы.СуммаВР;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОтражениеВУчетеЯвляетсяОснованиемОформленияКассовогоЧекаПриИзменении(Элемент)
	
	ДанныеСтроки = Элементы.ОтражениеВУчете.ТекущиеДанные;
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДанныеСтроки.ОписаниеУдержанияДляЧека) И Не ДанныеСтроки.ЯвляетсяОснованиемОформленияКассовогоЧека Тогда
		ДанныеСтроки.ОписаниеУдержанияДляЧека = "";
		ДанныеСтроки.ФизическоеЛицо           = "";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();


	// ОтражениеВУчетеПодразделениеДт

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ОтражениеВУчетеПодразделениеДт");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.ОтражениеВУчете.ПодразделениеДтДоступность", ВидСравненияКомпоновкиДанных.Равно, Ложь);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);


	// ОтражениеВУчетеПодразделениеКт

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ОтражениеВУчетеПодразделениеКт");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.ОтражениеВУчете.ПодразделениеКтДоступность", ВидСравненияКомпоновкиДанных.Равно, Ложь);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);

	// Фиксация 1 субконто для сохранения внешнего вида формы
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ОтражениеВУчетеСубконтоДт1");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
	"Объект.ОтражениеВУчете.СубконтоДт1Доступность", ВидСравненияКомпоновкиДанных.Равно, Ложь);
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Доступность", Ложь);
	
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ОтражениеВУчетеСубконтоКт1");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
	"Объект.ОтражениеВУчете.СубконтоКт1Доступность", ВидСравненияКомпоновкиДанных.Равно, Ложь);
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Доступность", Ложь);
	
	// Субконто
	Для Сч = 2 По 3 Цикл

		// СубконтоДт

		ЭлементУО = УсловноеОформление.Элементы.Добавить();

		КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ОтражениеВУчетеСубконтоДт" + Сч);

		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
			"Объект.ОтражениеВУчете.СубконтоДт" + Сч + "Доступность", ВидСравненияКомпоновкиДанных.Равно, Ложь);

		ЭлементУО.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
		
		
		// СубконтоКт

		ЭлементУО = УсловноеОформление.Элементы.Добавить();

		КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ОтражениеВУчетеСубконтоКт" + Сч);

		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
			"Объект.ОтражениеВУчете.СубконтоКт" + Сч + "Доступность", ВидСравненияКомпоновкиДанных.Равно, Ложь);

		ЭлементУО.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
		
	КонецЦикла;
	
	// ОтражениеВУчетеФизическоеЛицо, ОтражениеВУчетеОписаниеУдержанияДляЧека

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ОтражениеВУчетеФизическоеЛицо");
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ОтражениеВУчетеОписаниеУдержанияДляЧека");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.ОтражениеВУчете.ЯвляетсяОснованиемОформленияКассовогоЧека", ВидСравненияКомпоновкиДанных.Равно, Ложь);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьФормуНаСервере()

	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);

	ПлательщикНалогаНаПрибыль = УчетнаяПолитика.ПлательщикНалогаНаПрибыль(Объект.Организация, Объект.Дата);
	
	ЗаполнитьДобавленныеКолонкиТаблиц();
	
	УстановитьСостояниеДокумента();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииСервер()

	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);
	ПлательщикНалогаНаПрибыль = УчетнаяПолитика.ПлательщикНалогаНаПрибыль(Объект.Организация, Объект.Дата);
	
	БухгалтерскийУчетКлиентСервер.УстановитьСвойстваСубконтоТаблицыПриИзмененииОрганизации(
		Объект.ОтражениеВУчете,
		ПараметрыУстановкиСвойствСубконтоДт(ЭтотОбъект));
	БухгалтерскийУчетКлиентСервер.УстановитьСвойстваСубконтоТаблицыПриИзмененииОрганизации(
		Объект.ОтражениеВУчете,
		ПараметрыУстановкиСвойствСубконтоКт(ЭтотОбъект));

КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииСервер()

	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);
	ПлательщикНалогаНаПрибыль = УчетнаяПолитика.ПлательщикНалогаНаПрибыль(Объект.Организация, Объект.Дата);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДобавленныеКолонкиТаблиц()
	
	БухгалтерскийУчетКлиентСервер.УстановитьНачальныеСвойстваСубконтоТаблицы(
		Объект.ОтражениеВУчете,
		ПараметрыУстановкиСвойствСубконтоДт(ЭтотОбъект));
	БухгалтерскийУчетКлиентСервер.УстановитьНачальныеСвойстваСубконтоТаблицы(
		Объект.ОтражениеВУчете,
		ПараметрыУстановкиСвойствСубконтоКт(ЭтотОбъект));
	
	Для каждого СтрокаТаблицы Из Объект.ОтражениеВУчете Цикл
		ЗаполнитьНадписиВПроводке(СтрокаТаблицы);
	КонецЦикла;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьНадписиВПроводке(СтрокаТаблицы)
	
	СтрокаТаблицы.НадписьНУ = НСтр("ru = 'НУ:'");
	СтрокаТаблицы.НадписьПР = НСтр("ru = 'ПР:'");
	СтрокаТаблицы.НадписьВР = НСтр("ru = 'ВР:'");

КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииСубконтоДт(НомерСубконто)
	
	БухгалтерскийУчетКлиентСервер.УстановитьСвойстваСубконтоСтрокиПриИзмененииСубконто(
		ЭтотОбъект, 
		Элементы.ОтражениеВУчете.ТекущиеДанные,
		НомерСубконто, 
		ПараметрыУстановкиСвойствСубконтоДт(ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииСубконтоКт(НомерСубконто)
	
	БухгалтерскийУчетКлиентСервер.УстановитьСвойстваСубконтоСтрокиПриИзмененииСубконто(
		ЭтотОбъект, 
		Элементы.ОтражениеВУчете.ТекущиеДанные,
		НомерСубконто, 
		ПараметрыУстановкиСвойствСубконтоКт(ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура НачалоВыбораСубконтоДт(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДанныеОбъекта = БухгалтерскийУчетКлиентСервер.ДанныеУстановкиПараметровСубконто(
		Элементы.ОтражениеВУчете.ТекущиеДанные,
		ПараметрыУстановкиСвойствСубконтоДт(ЭтотОбъект));
	
	ОбщегоНазначенияБПКлиент.НачалоВыбораЗначенияСубконто(ЭтотОбъект, Элемент, СтандартнаяОбработка, ДанныеОбъекта);
	
КонецПроцедуры

&НаКлиенте
Процедура НачалоВыбораСубконтоКт(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДанныеОбъекта = БухгалтерскийУчетКлиентСервер.ДанныеУстановкиПараметровСубконто(
		Элементы.ОтражениеВУчете.ТекущиеДанные,
		ПараметрыУстановкиСвойствСубконтоКт(ЭтотОбъект));
	
	ОбщегоНазначенияБПКлиент.НачалоВыбораЗначенияСубконто(ЭтотОбъект, Элемент, СтандартнаяОбработка, ДанныеОбъекта);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПараметрыУстановкиСвойствСубконтоДт(Форма)

	Результат = БухгалтерскийУчетКлиентСервер.ПараметрыУстановкиСвойствСубконтоПоШаблону(
		"ОтражениеВУчетеСубконтоДт", "ОтражениеВУчетеПодразделениеДт", "СубконтоДт", "ПодразделениеДт", "СчетДт");
		
	Результат.ДопРеквизиты.Вставить("Организация", Форма.Объект.Организация);
	Результат.СкрыватьСубконто = Ложь;
	
	Возврат Результат;

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПараметрыУстановкиСвойствСубконтоКт(Форма)

	Результат = БухгалтерскийУчетКлиентСервер.ПараметрыУстановкиСвойствСубконтоПоШаблону(
		"ОтражениеВУчетеСубконтоКт", "ОтражениеВУчетеПодразделениеКт", "СубконтоКт", "ПодразделениеКт", "СчетКт");
		
	Результат.ДопРеквизиты.Вставить("Организация", Форма.Объект.Организация);
	Результат.СкрыватьСубконто = Ложь;
	
	Возврат Результат;

КонецФункции

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

#КонецОбласти
