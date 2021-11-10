﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Определяет поддерживаемый набор суммовых показателей справки-расчета.
// См. соответствующие методы модулей подсистемы СправкиРасчеты.
// Справка-расчет должна поддерживать хотя бы один набор.
// Если поддерживается несколько наборов, то конкретный набор выбирается в форме
// и передается через свойство отчета НаборПоказателейОтчета.
//
// См. также ПолучитьНаборПоказателей
//
// Возвращаемое значение:
//  Массив - номера наборов суммовых показателей.
//
Функция ПоддерживаемыеНаборыСуммовыхПоказателей() Экспорт
	
	Возврат СправкиРасчетыКлиентСервер.ВсеНаборыСуммовыхПоказателей();
	
КонецФункции

#КонецОбласти

#Область ОбработчикиБухгалтерскиеОтчеты

Функция ПолучитьТекстЗаголовка(Контекст) Экспорт 
	
	Возврат СправкиРасчеты.ЗаголовокОтчета(Контекст);
	
КонецФункции

Процедура ПриВыводеЗаголовка(Контекст, КомпоновщикНастроек, Результат) Экспорт
	
	СправкиРасчеты.ВывестиШапкуОтчета(Результат, Контекст);
	
КонецПроцедуры

Процедура ПослеВыводаРезультата(Контекст, Результат) Экспорт
	
	СправкиРасчеты.ОформитьРезультатОтчета(Результат, Контекст);
	
КонецПроцедуры

#КонецОбласти
	
Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИспользоватьПередКомпоновкойМакета", Истина);
	Результат.Вставить("ИспользоватьПослеКомпоновкиМакета",  Истина);
	Результат.Вставить("ИспользоватьПослеВыводаРезультата",  Истина);
	Результат.Вставить("ИспользоватьДанныеРасшифровки",      Ложь);
	Результат.Вставить("ИспользоватьПриВыводеЗаголовка",     Истина);
	
	Возврат Результат;
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоДня(ПараметрыОтчета.НачалоПериода));
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НалоговыйУчет", ПараметрыОтчета.ПоказательНУ);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СчетаЗапасов", УчетЗатрат.ПредопределенныеСчетаЗапасов());
		
	СуффиксГруппировок = "";
	Таблица = БухгалтерскиеОтчеты.НайтиПоИмени(КомпоновщикНастроек.Настройки.Структура, "Таблица");
	
	ИспользуютсяОбозначенияПоказателей = (ПараметрыОтчета.СоставНабораПоказателей.Количество() > 1);
	
	ИспользуетсяПлановаяСебестоимость = УчетнаяПолитика.ПлановаяСебестоимость(ПараметрыОтчета.Организация, КонецДня(ПараметрыОтчета.КонецПериода));
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ИспользуетсяПлановаяСебестоимость", ИспользуетсяПлановаяСебестоимость);
	
	Если НЕ ИспользуетсяПлановаяСебестоимость Тогда 
		СуффиксГруппировок = "БезПлановыхЦен";
	КонецЕсли;
	
	Если ИспользуютсяОбозначенияПоказателей Тогда 
		СуффиксГруппировок = СуффиксГруппировок + "СРазницами";
	КонецЕсли;
	
	Если ПараметрыОтчета.ПоказательНУ И Не ПараметрыОтчета.ПоказательБУ Тогда
		ИмяРесурсаОтклонений = "ОтклонениеФактическойСебестоимостиНУ";
	Иначе
		ИмяРесурсаОтклонений = "ОтклонениеФактическойСебестоимостиБУ";
	КонецЕсли;
	
	ГруппировкаПериод = БухгалтерскиеОтчеты.НайтиПоИмени(Таблица.Строки, "Период"+СуффиксГруппировок);
	ГруппировкаПериод.Использование = Истина;
	
	ГруппировкаВидБазы 	 	 = БухгалтерскиеОтчеты.НайтиПоИмени(ГруппировкаПериод.Структура, "ВидБазыРаспределения"+СуффиксГруппировок);
	ГруппировкаСчет 	 	 = БухгалтерскиеОтчеты.НайтиПоИмени(ГруппировкаПериод.Структура, "Счет");
	ГруппировкаПодразделение = БухгалтерскиеОтчеты.НайтиПоИмени(ГруппировкаПериод.Структура, "Подразделение");	
	ГруппировкаНомГруппа 	 = БухгалтерскиеОтчеты.НайтиПоИмени(ГруппировкаПериод.Структура, "НоменклатурнаяГруппа");
	ГруппировкаПродукция 	 = БухгалтерскиеОтчеты.НайтиПоИмени(ГруппировкаПериод.Структура, "Продукция");
	
	Если НачалоМесяца(ПараметрыОтчета.НачалоПериода) = НачалоМесяца(ПараметрыОтчета.КонецПериода) 
		И ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		ГруппировкаПериод.Состояние = СостояниеЭлементаНастройкиКомпоновкиДанных.Отключен;
		ПараметрыОтчета.ВыполнениеОтчета.Вставить("ГруппироватьПоПериоду", Ложь);
		ГруппировкаВидБазы.ПараметрыВывода.УстановитьЗначениеПараметра("РасположениеИтогов", РасположениеИтоговКомпоновкиДанных.Конец);
	КонецЕсли;	
	
	Если Не ПолучитьФункциональнуюОпцию("ВестиУчетЗатратПоПодразделениям") Тогда
		ГруппировкаПодразделение.Состояние = СостояниеЭлементаНастройкиКомпоновкиДанных.Отключен;
		ПараметрыОтчета.ВыполнениеОтчета.Вставить("ГруппироватьПоПодразделению", Ложь);
	КонецЕсли;	
		
	// ПОКАЗАТЕЛИ ГРУППИРОВКИ ПО ПЕРИОДУ
	
	Группировки = Новый Структура;
	Группировки.Вставить("Период", 				 ГруппировкаПериод);
	Группировки.Вставить("ВидБазыРаспределения", ГруппировкаВидБазы); // настроен макет
	Группировки.Вставить("Счет",				 ГруппировкаСчет);
	Группировки.Вставить("Подразделение",		 ГруппировкаПодразделение);
	Группировки.Вставить("НоменклатурнаяГруппа", ГруппировкаНомГруппа);
	Группировки.Вставить("Продукция",			 ГруппировкаПродукция);
	
	// Выводим показатели группировок
	Для Каждого НастройкаГруппировка Из Группировки Цикл
		
		ИмяГруппировки = НастройкаГруппировка.Ключ;
		Группировка = НастройкаГруппировка.Значение;
		
		Если Группировка.Состояние = СостояниеЭлементаНастройкиКомпоновкиДанных.Отключен Тогда
			Продолжить;
		КонецЕсли;	
		
		// КОЛОНКИ 1-2
		Если ИмяГруппировки = "Продукция" Тогда
			// НоменклатурнаяГруппа в этой группировке используется только для совместимости колонок -
			// текст скрывается настройкой условного оформления - см. СКД
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группировка.Выбор, "НоменклатурнаяГруппа");
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группировка.Выбор, "Номенклатура");
		Иначе
			Группировка.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
		КонецЕсли;	
				
		// КОЛОНКА 2.а
		Если ИспользуютсяОбозначенияПоказателей Тогда
			Группа = Группировка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
			Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
			ДобавитьГруппуПоказателей(Группа, ПараметрыОтчета.СоставНабораПоказателей, ПараметрыОтчета, "Показатели.");
		КонецЕсли;
		
		// КОЛОНКА 3
		Группа = Группировка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
		ДобавитьГруппуПоказателей(Группа, ПараметрыОтчета.СоставНабораПоказателей, ПараметрыОтчета, "Ресурсы.ПрямыеРасходы");
		
		// КОЛОНКА 4
		Группа = Группировка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
		
		Если ИмяГруппировки = "Продукция" Тогда
			// РаспределяемыеРасходы в этой группировке используется только для совместимости колонок -
			// текст скрывается настройкой условного оформления - см. СКД
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, "Ресурсы.РаспределяемыеРасходыБУ");
		Иначе	
			ДобавитьГруппуПоказателей(Группа, ПараметрыОтчета.СоставНабораПоказателей, ПараметрыОтчета, "Ресурсы.РаспределяемыеРасходы");
		КонецЕсли;	
		
		// КОЛОНКА 5
		Группа = Группировка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, "Ресурсы.БазаРаспределения");
		
		// КОЛОНКА 6
		Группа = Группировка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, "Ресурсы.Коэффициент");
				
		// КОЛОНКА 7
		Группа = Группировка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
		ДобавитьГруппуПоказателей(Группа, ПараметрыОтчета.СоставНабораПоказателей, ПараметрыОтчета, "Ресурсы.КосвенныеРасходы");
				
		// КОЛОНКА 8
		Группа = Группировка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
		ДобавитьГруппуПоказателей(Группа, ПараметрыОтчета.СоставНабораПоказателей, ПараметрыОтчета, "Ресурсы.Сумма");
		
		Если ИспользуетсяПлановаяСебестоимость Тогда
			
			// КОЛОНКА 9
			Группа = Группировка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
			Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа,"Ресурсы.СуммаПлан");
			
			// КОЛОНКА 10
			Группа = Группировка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
			Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, "Ресурсы." + ИмяРесурсаОтклонений);
			
		КонецЕсли;
	
	КонецЦикла;
		
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	
КонецПроцедуры

Процедура ПослеКомпоновкиМакета(ПараметрыОтчета, МакетКомпоновки) Экспорт
	
	ГруппироватьПоПериоду = Истина;
	Если ПараметрыОтчета.ВыполнениеОтчета.Свойство("ГруппироватьПоПериоду") Тогда
		ГруппироватьПоПериоду = ПараметрыОтчета.ВыполнениеОтчета.ГруппироватьПоПериоду;
	КонецЕсли;	
	
	ГруппироватьПоПодразделению = Истина;
	Если ПараметрыОтчета.ВыполнениеОтчета.Свойство("ГруппироватьПоПодразделению") Тогда
		ГруппироватьПоПодразделению = ПараметрыОтчета.ВыполнениеОтчета.ГруппироватьПоПодразделению;
	КонецЕсли;	
		
	ПараметрыПоиска = БухгалтерскиеОтчеты.ПараметрыПоискаВТелеМакетаКомпоновки();
	ПараметрыПоиска.СвойствоДляИдентификации = "ТипЭлемента";
	КорневаяГруппировка = БухгалтерскиеОтчеты.ПодобратьЭлементыИзТелаМакета(
							МакетКомпоновки, "ТаблицаМакетаКомпоновкиДанных", ПараметрыПоиска);
	КорневаяГруппировка = КорневаяГруппировка.Строки[0]; // Период или ВидБазыРаспределения
	
	Если ГруппироватьПоПериоду Тогда
		// Удаляем лишний заголовок (у группировки ВидБазыРаспределения).
		КорневаяГруппировка.Тело.Удалить(КорневаяГруппировка.Тело[1]);
	КонецЕсли;	
	
	Линия = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Двойная,1);
	ЦветФонаСчет = Неопределено;
	
	МакетКорневойГруппировки = МакетКомпоновки.Макеты[КорневаяГруппировка.Тело[0].Макет];
	Если ТипЗнч(МакетКорневойГруппировки.Макет) = Тип("МакетОбластиКомпоновкиДанных") Тогда
		// Граница сверху в 1-й строке макета корневой группировки
		Для каждого Ячейка Из МакетКорневойГруппировки.Макет[0].Ячейки Цикл  // ячейки первой строки макета
			ГраницаСверху = Ячейка.Оформление.Элементы.Найти("СтильГраницы").ЗначенияВложенныхПараметров.Найти("СтильГраницы.Сверху");
			ГраницаСверху.Значение = Линия;
			ГраницаСверху.Использование = Истина;
		КонецЦикла;  	
	КонецЕсли;
	
	ПараметрыПоиска.СвойствоДляИдентификации = "Группировка";
	ГруппировкаСчет = БухгалтерскиеОтчеты.ПодобратьЭлементыИзТелаМакета(
						КорневаяГруппировка, "Счет", ПараметрыПоиска);

	// Определим цвет фона группировки Счет, чтобы ниже установить такой же фон для Подразделение и НоменклатурнаяГруппа
	МакетГруппировкиСчет = МакетКомпоновки.Макеты[ГруппировкаСчет.Тело[0].Макет];
	Если ТипЗнч(МакетГруппировкиСчет.Макет) = Тип("МакетОбластиКомпоновкиДанных") Тогда
		// Определяем цвет фона по 1-й ячейке 1-й строки макета
		ЦветФонаСчет = МакетГруппировкиСчет.Макет[0].Ячейки[0].Оформление.Элементы.Найти("ЦветФона").Значение;
		// При использовании некоторых макетов оформления в группировке Счет ЦветФона = АвтоЦвет
		Если ЦветФонаСчет.Красный = 0 И ЦветФонаСчет.Зеленый = 0 И ЦветФонаСчет.Синий = 0 Тогда
			ЦветФонаСчет = Новый Цвет; //АвтоЦвет
		КонецЕсли; 
	КонецЕсли;
	
	МакетОбщегоИтога = МакетКомпоновки.Макеты[КорневаяГруппировка.МакетПодвала.Макет];	
	Если ТипЗнч(МакетОбщегоИтога.Макет) = Тип("МакетОбластиКомпоновкиДанных") Тогда
	
		// Граница слева в строке общего итога.
		// Устанавливаем границу для 1-й ячейки каждой строки макета.
		Для Каждого СтрокаМакета Из МакетОбщегоИтога.Макет Цикл
			ГраницаСлева = СтрокаМакета.Ячейки[0].Оформление.Элементы.Найти("СтильГраницы").ЗначенияВложенныхПараметров.Найти("СтильГраницы.Слева");
			ГраницаСлева.Значение = Линия;
			ГраницаСлева.Использование = Истина;
		КонецЦикла; 
			
		// Граница сверху в 1-й строке макета общего итога
		Для каждого Ячейка Из МакетОбщегоИтога.Макет[0].Ячейки Цикл // ячейки первой строки макета
			ГраницаСверху = Ячейка.Оформление.Элементы.Найти("СтильГраницы").ЗначенияВложенныхПараметров.Найти("СтильГраницы.Сверху");
			ГраницаСверху.Значение = Линия;
			ГраницаСверху.Использование = Истина;
		КонецЦикла;  
		
	КонецЕсли;	
		
	Если ГруппироватьПоПодразделению Тогда
		
		ГруппировкаПодразделение = БухгалтерскиеОтчеты.ПодобратьЭлементыИзТелаМакета(
							ГруппировкаСчет, "Подразделение", ПараметрыПоиска);
		МакетГруппировкиПодразделение = МакетКомпоновки.Макеты[ГруппировкаПодразделение.Тело[0].Макет];
		Если ТипЗнч(МакетГруппировкиПодразделение.Макет) = Тип("МакетОбластиКомпоновкиДанных") И ЦветФонаСчет <> Неопределено Тогда
			// Цвет фона как в группировке Счет
			Для Каждого СтрокаМакета Из МакетГруппировкиПодразделение.Макет Цикл
				Для каждого Ячейка Из СтрокаМакета.Ячейки Цикл
					ЦветФона = Ячейка.Оформление.Элементы.Найти("ЦветФона");
					ЦветФона.Значение = ЦветФонаСчет;
					ЦветФона.Использование = Истина;
				КонецЦикла;  
			КонецЦикла; 
		КонецЕсли;
		
	КонецЕсли;

	ГруппировкаНомГруппа = БухгалтерскиеОтчеты.ПодобратьЭлементыИзТелаМакета(
							ГруппировкаСчет, "НоменклатурнаяГруппа", ПараметрыПоиска);
	МакетГруппировкиНомГруппа = МакетКомпоновки.Макеты[ГруппировкаНомГруппа.Тело[0].Макет];
	Если ТипЗнч(МакетГруппировкиНомГруппа.Макет) = Тип("МакетОбластиКомпоновкиДанных") И ЦветФонаСчет <> Неопределено Тогда
		// Цвет фона как в группировке Счет
		Для Каждого СтрокаМакета Из МакетГруппировкиНомГруппа.Макет Цикл
			Для каждого Ячейка Из СтрокаМакета.Ячейки Цикл
				ЦветФона = Ячейка.Оформление.Элементы.Найти("ЦветФона");
				ЦветФона.Значение = ЦветФонаСчет;
				ЦветФона.Использование = Истина;
			КонецЦикла;  
		КонецЦикла; 
	КонецЕсли;
	
	//Удаляем лишние итоги
	КорневаяГруппировка.Тело.Удалить(КорневаяГруппировка.Тело[2]);

КонецПроцедуры

Функция ПолучитьНаборПоказателей() Экспорт
	
	//См. ПоддерживаемыеНаборыСуммовыхПоказателей
	Возврат СправкиРасчетыКлиентСервер.ВсеПоказателиОтчета();
	
КонецФункции

Процедура НастроитьВариантыОтчета(Настройки, ОписаниеОтчета) Экспорт
	
	Схема = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	Для Каждого Вариант из Схема.ВариантыНастроек Цикл
		ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, Вариант.Имя).Размещение.Вставить(
			Метаданные.Подсистемы.Отчеты.Подсистемы.СправкиРасчеты.Подсистемы.БухгалтерскийУчет, "");
		ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, Вариант.Имя).Размещение.Вставить(
			Метаданные.Подсистемы.Отчеты.Подсистемы.СправкиРасчеты.Подсистемы.БухгалтерскийИНалоговыйУчет, "");
		ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, Вариант.Имя).Размещение.Вставить(
			Метаданные.Подсистемы.БухгалтерияПредприятияПодсистемы.Подсистемы.ПростойИнтерфейс.Подсистемы.Отчеты.Подсистемы.СправкиРасчеты, "");
	КонецЦикла;	
	
КонецПроцедуры

//Процедура используется подсистемой варианты отчетов
//
Процедура НастройкиОтчета(Настройки) Экспорт
	
	Схема = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	Для Каждого Вариант из Схема.ВариантыНастроек Цикл
		 Настройки.ОписаниеВариантов.Вставить(Вариант.Имя,Вариант.Представление);
	КонецЦикла;	
	
КонецПроцедуры

Процедура ДобавитьГруппуПоказателей(РодительскаяГруппа, СоставНабораПоказателей, ПараметрыОтчета, ИмяПоля)
	
	ГруппировкаПоказатели = РодительскаяГруппа.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппировкаПоказатели.Расположение = РасположениеПоляКомпоновкиДанных.Вертикально;
	
	Для Каждого ИмяПоказателя Из СоставНабораПоказателей Цикл
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппировкаПоказатели, ИмяПоля+ИмяПоказателя);
	КонецЦикла;
	
КонецПроцедуры

#КонецЕсли