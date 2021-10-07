﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Возвращает имя области макета списков, в котором содержится ограничение
// классификатора для переданного значения перечисления (ВидыСвободныхСтрокФормСтатистики)
//
Функция ИмяОбластиМакетаОграничения(Значение, ВерсияСписка = "") Экспорт
	
	ИмяОбластиМакетаОграничения = Неопределено;
	
	Если Значение = ВидыДеятельности Тогда
		
		ИмяОбластиМакетаОграничения = "pril_okved_51";	
		
	ИначеЕсли Значение = ВидыПродукцииПроизводство Тогда	
		
		Если ВерсияСписка = "Списки2010Кв1" Тогда
			ИмяОбластиМакетаОграничения = "pril_okp_50";	
		Иначе	
			ИмяОбластиМакетаОграничения = "pril_okp_55";	
		КонецЕсли;
		
	ИначеЕсли Значение = ВидыПродукцииРозница Тогда	
		
		ИмяОбластиМакетаОграничения = "pril_okp_6";	
		
	ИначеЕсли Значение = ВидыПродукцииОпт Тогда	
		
		ИмяОбластиМакетаОграничения = "pril_okp_7";	
		
	ИначеЕсли Значение = ВидыУслугРозница Тогда	
		
		ИмяОбластиМакетаОграничения = "pril_okp_U";	
		
	КонеЦесли;
	
	Возврат ИмяОбластиМакетаОграничения;	
	
КонецФункции

// Возвращает список значений перечисления которыми может ограничиваться отбор для переданного классификатора
//Параметры:
// - Классификатор - Строка, имя справочника
//
Функция СписокНазначенийДляКлассификатора(Классификатор) Экспорт
	
	СписокОграничений = Новый СписокЗначений();
	
	Если Классификатор = "КлассификаторВидовЭкономическойДеятельности" Тогда
		
		СписокОграничений.Добавить(ВидыДеятельности, "Виды деятельности для форм статистики");
		
	ИначеЕсли Классификатор = "КлассификаторПродукцииПоВидамДеятельности" Тогда
	
		СписокОграничений.Добавить(ВидыПродукцииПроизводство, 	"Производственная продукция");
		СписокОграничений.Добавить(ВидыПродукцииОпт, 			"Товары в оптовой торговле");
		СписокОграничений.Добавить(ВидыПродукцииРозница, 		"Товары в рознице");
		СписокОграничений.Добавить(ВидыУслугРозница,			"Услуги");
		
	КонецЕсли;	
	
	Возврат СписокОграничений;
	
КонецФункции

// Возвращает имя области макета списков, в котором содержатся данные
//	о единицах измерения для переданного значения перечисления
// Параметры:
// - Значение - Перечисления.ВидыСвободныхСтрокФормСтатистики
//
Функция ИмяОбластиЕдиницаИзмерения(Значение) Экспорт
	
	ИмяОбластиЕдиницаИзмерения = Неопределено;
	
	Если Значение = ВидыПродукцииПроизводство Тогда	
		
		ИмяОбластиЕдиницаИзмерения = "s_okp_ei_50";	
		
	ИначеЕсли Значение = ВидыПродукцииРозница Тогда	
		
		ИмяОбластиЕдиницаИзмерения = "s_okp_ei_70";	
		
	ИначеЕсли Значение = ВидыПродукцииОпт Тогда	
		
		ИмяОбластиЕдиницаИзмерения = "s_okp_ei_80";	
		
	КонеЦесли;	
	
	Возврат ИмяОбластиЕдиницаИзмерения;	
	
КонецФункции

// Возвращает значение перечисления соответствующее переданному классификатору
// для классификаторов которым соответствует несколько перечислений возвращается - неопределено
//Параметры:
// - Классификатор - Строка, имя справочника
//
Функция ЗначениеПоУмолчаниюДляКлассификатора(Классификатор) Экспорт
	
	Значение = Неопределено;
	
	Если Классификатор = "КлассификаторВидовЭкономическойДеятельности" Тогда
		
		Значение = ВидыДеятельности;
		
	ИначеЕсли Классификатор = "КлассификаторУслугНаселению" Тогда
	
		Значение = УслугиНаселению;
	
	КонецЕсли;	
	
	Возврат Значение;
	
КонецФункции

Функция КраткоеПредставлениеКлассификатора(Значение) Экспорт
	
	Если Значение = ВидыДеятельности Тогда
		Возврат НСтр("ru = 'ОКВЭД'");
	ИначеЕсли Значение = ВидыПродукцииОпт
		ИЛИ Значение = ВидыПродукцииПроизводство
		ИЛИ Значение = ВидыПродукцииРозница
		ИЛИ Значение = ВидыУслугРозница 
		Тогда
		Возврат НСтр("ru = 'ОКПД'");
	ИначеЕсли Значение = УслугиНаселению Тогда
		Возврат НСтр("ru = 'ОКУН'");
	Иначе
		Возврат НСтр("");
	КонецЕсли;
	
КонецФункции

Функция ТипКлассификатора(Значение) Экспорт
	
	Если Значение = ВидыДеятельности Тогда
		Возврат Тип("СправочникСсылка.КлассификаторВидовЭкономическойДеятельности");
	ИначеЕсли Значение = ВидыПродукцииОпт
		ИЛИ Значение = ВидыПродукцииПроизводство
		ИЛИ Значение = ВидыПродукцииРозница
		ИЛИ Значение = ВидыУслугРозница
		Тогда
		Возврат Тип("СправочникСсылка.КлассификаторПродукцииПоВидамДеятельности");
	ИначеЕсли Значение = УслугиНаселению Тогда
		Возврат Тип("СправочникСсылка.КлассификаторУслугНаселению");
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

Функция ИмяСправочника(Значение) Экспорт
		
	Если Значение = ВидыДеятельности Тогда
		Возврат "КлассификаторВидовЭкономическойДеятельности";
	ИначеЕсли Значение = ВидыПродукцииОпт
		ИЛИ Значение = ВидыПродукцииПроизводство
		ИЛИ Значение = ВидыПродукцииРозница
		ИЛИ Значение = ВидыУслугРозница
		Тогда
		Возврат "КлассификаторПродукцииПоВидамДеятельности";
	ИначеЕсли Значение = УслугиНаселению Тогда
		Возврат "КлассификаторУслугНаселению";
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

#КонецЕсли