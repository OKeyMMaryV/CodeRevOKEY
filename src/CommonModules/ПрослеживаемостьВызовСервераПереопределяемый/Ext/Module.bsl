﻿#Область ПрограммныйИнтерфейс

// Функция возвращает вес товара по сертификату, для расчета в единице прослеживаемости кг
//
// Параметры:
//  Номенклатура - СправочникСсылка.Номенкатура - номенклатура
// 
// Возвращемое значение:
//  Число - вес по сертификату
//
Функция ВесТовараПоСертификату(Номенклатура) Экспорт
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Номенклатура, "ВесПоСертификатуТовара");
	
КонецФункции

&НаСервере
Функция ПолучитьТаблицуТоваровПоТНВЭД(Объект) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РегистрацияПрослеживаемыхТоваров.Номенклатура КАК Номенклатура,
	|	СУММА(РегистрацияПрослеживаемыхТоваров.Количество) КАК Количество,
	|	СУММА(РегистрацияПрослеживаемыхТоваров.Сумма) КАК Сумма,
	|	НоменклатураСправочник.КодОКПД2 КАК КодОКПД2,
	|	НоменклатураСправочник.КодТНВЭД КАК КодТНВЭД,
	|	НоменклатураСправочник.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	КлассификаторТНВЭД.ЕдиницаИзмерения КАК ЕдиницаПрослеживаемости,
	|	ВЫБОР
	|		КОГДА НоменклатураСправочник.ВесПоСертификатуТовара > 0
	|			ТОГДА РегистрацияПрослеживаемыхТоваров.Количество * НоменклатураСправочник.ВесПоСертификатуТовара
	|		ИНАЧЕ РегистрацияПрослеживаемыхТоваров.Количество
	|	КОНЕЦ КАК КоличествоПрослеживаемости,
	|	НоменклатураСправочник.СтранаПроисхождения КАК СтранаПроисхождения
	|ПОМЕСТИТЬ ТаблицаТоваров
	|ИЗ
	|	РегистрСведений.РегистрацияПрослеживаемыхТоваров КАК РегистрацияПрослеживаемыхТоваров
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК НоменклатураСправочник
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлассификаторТНВЭД КАК КлассификаторТНВЭД
	|			ПО НоменклатураСправочник.КодТНВЭД = КлассификаторТНВЭД.Ссылка
	|		ПО РегистрацияПрослеживаемыхТоваров.Номенклатура = НоменклатураСправочник.Ссылка
	|ГДЕ
	|	НоменклатураСправочник.КодТНВЭД = &КодТНВЭД
	|	И РегистрацияПрослеживаемыхТоваров.Организация = &Организация
	|	И РегистрацияПрослеживаемыхТоваров.Основание = &ДокументОснование
	|
	|СГРУППИРОВАТЬ ПО
	|	НоменклатураСправочник.КодОКПД2,
	|	НоменклатураСправочник.КодТНВЭД,
	|	НоменклатураСправочник.ЕдиницаИзмерения,
	|	КлассификаторТНВЭД.ЕдиницаИзмерения,
	|	ВЫБОР
	|		КОГДА НоменклатураСправочник.ВесПоСертификатуТовара > 0
	|			ТОГДА РегистрацияПрослеживаемыхТоваров.Количество * НоменклатураСправочник.ВесПоСертификатуТовара
	|		ИНАЧЕ РегистрацияПрослеживаемыхТоваров.Количество
	|	КОНЕЦ,
	|	РегистрацияПрослеживаемыхТоваров.Номенклатура,
	|	НоменклатураСправочник.СтранаПроисхождения
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	СУММА(ТаблицаТоваров.Количество) КАК Количество,
	|	СУММА(ТаблицаТоваров.Сумма) КАК Сумма,
	|	ТаблицаТоваров.КодОКПД2 КАК КодОКПД2,
	|	ТаблицаТоваров.КодТНВЭД КАК КодТНВЭД,
	|	ТаблицаТоваров.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ТаблицаТоваров.ЕдиницаПрослеживаемости КАК ЕдиницаПрослеживаемости,
	|	СУММА(ТаблицаТоваров.КоличествоПрослеживаемости) КАК КоличествоПрослеживаемости,
	|	ТаблицаТоваров.СтранаПроисхождения КАК СтранаПроисхождения
	|ИЗ
	|	ТаблицаТоваров КАК ТаблицаТоваров
	|ГДЕ
	|	ТаблицаТоваров.Количество > 0
	|	И ТаблицаТоваров.ЕдиницаИзмерения = &ЕдиницаИзмерения
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаТоваров.ЕдиницаПрослеживаемости,
	|	ТаблицаТоваров.КодОКПД2,
	|	ТаблицаТоваров.Номенклатура,
	|	ТаблицаТоваров.КодТНВЭД,
	|	ТаблицаТоваров.ЕдиницаИзмерения,
	|	ТаблицаТоваров.СтранаПроисхождения";
	
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	
	МоментСписания = Новый Граница(Объект.Ссылка.МоментВремени(), ВидГраницы.Исключая);
	Запрос.УстановитьПараметр("МоментСписания", МоментСписания);
	Запрос.УстановитьПараметр("ДокументОснование", Объект.ПервичныйДокумент);
	Запрос.УстановитьПараметр("КодТНВЭД", Объект.КодТНВЭД);
	Запрос.УстановитьПараметр("ЕдиницаИзмерения", Объект.ЕдиницаИзмерения);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьСведенияПрослеживаемогоТовара(Номенклатура, ДанныеОбъекта) Экспорт
	
	СведенияОНоменклатуре = Новый Структура("ЕдиницаИзмерения,ЕдиницаПрослеживаемости,КодОКПД2,СтранаПроисхождения");
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КлассификаторТНВЭД.ЕдиницаИзмерения КАК ЕдиницаПрослеживаемости,
	|	Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	Номенклатура.КодОКПД2 КАК КодОКПД2,
	|	Номенклатура.СтранаПроисхождения КАК СтранаПроисхождения
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлассификаторТНВЭД КАК КлассификаторТНВЭД
	|		ПО Номенклатура.КодТНВЭД = КлассификаторТНВЭД.Ссылка
	|ГДЕ
	|	Номенклатура.Ссылка = &Ссылка
	|	И Номенклатура.КодТНВЭД = &КодТНВЭД";
	
	Запрос.УстановитьПараметр("Ссылка", Номенклатура);
	Запрос.УстановитьПараметр("КодТНВЭД", ДанныеОбъекта.КодТНВЭД);
	
	Результат = Запрос.Выполнить().Выбрать();
	
	Если Результат.Следующий() Тогда
		
		ЗаполнитьЗначенияСвойств(СведенияОНоменклатуре, Результат);
		
	КонецЕсли;
	
	Возврат СведенияОНоменклатуре;
	
КонецФункции

Функция ПолучитьСписокПечатаемыхЛистовНаСервере(Ссылка) Экспорт
	
	Возврат 
		Документы.УведомлениеОПеремещенииПрослеживаемыхТоваров.ПолучитьСписокПечатныхФормУведомлениеОПеремещенииПрослеживаемыхТоваров(Ссылка);
	
КонецФункции

Функция ПолучитьСписокПечатаемыхЛистовУведомлениеОбОстатках(Ссылка) Экспорт
	
	Возврат 
		Документы.УведомлениеОбОстаткахПрослеживаемыхТоваров.ПолучитьПечатнуюФормуУведомлениеОбОстаткахПрослеживаемыхТоваров(Ссылка);
	
КонецФункции

Функция ПолучитьСписокПечатаемыхЛистовУведомлениеОВвозе(Ссылка) Экспорт
	
	Возврат 
		Документы.УведомлениеОВвозеПрослеживаемыхТоваров.ПолучитьПечатнуюФормуУведомления(Ссылка);
	
КонецФункции

// Возвращает структуру реквизитов для заполнения формы документов
// Параметры:
// КодТНВЭД - СправочникСсылка.КлассификаторТНВЭД - Выбранный код ТНВЭД
// 
// Возвращаемое значение:
// Структура - 
//				КодТНВЭД - Код ТН ВЭД
//				ЕдиницаИзмерения - СправочникСсылка.КлассификаторЕдиницИзмерения - Пустое значение
//				ЕдиницаПрослеживаемости - СправочникСсылка.КлассификаторЕдиницИзмерения - Единица прослеживаемости
//
Функция ПараметрыВыбранногоТНВЭД(КодТНВЭД) Экспорт
	
	Возврат Новый Структура("КодТНВЭД,ЕдиницаИзмерения,ЕдиницаПрослеживаемости", 
					КодТНВЭД,
					Справочники.КлассификаторЕдиницИзмерения.ПустаяСсылка(),
					ОбщегоНазначения.ЗначениеРеквизитаОбъекта(КодТНВЭД, "ЕдиницаИзмерения"));
	
КонецФункции

//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-10-21 (#4405)
Функция ДоступноРедактированиеФормыДанныхРНПТПоОС(ТекущийДокумент) Экспорт
	Возврат ПравоДоступа("Изменение", ТекущийДокумент.Метаданные());
КонецФункции
//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-10-21 (#4405)
#КонецОбласти
