﻿#Область ОписаниеМодуля
// Коллекции сумм предназначены для хранения некоторых наборов сумм.
// Над коллекциями и наборами можно выполнять различные арифметические действия.
//
// В коллекции сумм может содержаться произвольное количество наборов.
// Наборы именованные. К разным наборам могут применять разные правила обработки.
// Пример такого набора - "НалоговыйУчет" или "ЭлементыЗатрат".
//
// Наборы могут иметь фиксированный состав (перечеь сумм) или переменный.
//
// Суммы из наборов с фиксированным составом идентифицируются по имени суммы и хранятся в свойствах коллекции.
// Поэтому не допускаются одинаковые имена сумм в разных наборах.
//
// Суммы из наборов с переменном составом идентифицируются порядковым номером.
// Такие наборы хранятся в свойстве имя которого - имя набора.
// Поэтому не допускаются имена наборов идентичные именам сумм.
//
// Набор с переменным составом хранится в виде коллекции, 
// каждый элемент которой содержит порядковый номер и значение суммы 
// (в текущей реализации - ТаблицаЗначений с двумя колонками).
// Поэтому наборы такого вида уместно применять, когда набор сумм достаточно разреженный.
//
// Пример коллекции сумм:
// - Набор "БухгалтерскийУчет" с фиксированным составом - содержит 1 свойство "Сумма"
// - Набор "РазницыПоНалогуНаПрибыль" с фиксированным составом - содержит 2 свойства "СуммаПР", "СуммаВР"
// - Набор "ЭлементыЗатрат" с переменным составом
//
// Такая коллекция будет содержать свойства "Сумма", "СуммаПР", "СуммаВР" и "ЭлементыЗатрат"
// При этом первые три значения будут содержать тип Число, а третье - ТаблицаЗначений
//
// Коллекции сумм могут быть созданы конструктором, а могут иметь другой тип. 
// Если коллекция не создана конструктором:
// 1. Состав, тип и содержание свойств должны быть такими же, как при создании коллекции конструктором
// 2. имена свойств могут отличаться от тех, что заданы в описании.
//    Для "перевода" описание такой коллекции дополняется соответствием фактических имен свойств (полей) "каноническим", т.е. заданным в описании наборов.
//
// Примером коллекции, не созданной конструктором может быть выборка из запроса.
// Такая выборка может содержать несколько наборов полей для разных коллекций.
// Например: "Приход, ПриходПР, ПриходВР, Расход, РасходПР, РасходВР".
// Для того, чтобы с такой коллекцией можно было работать так же, как и с коллекцией, созданной в соответствии с примером выше,
// следует задать такое соответствие:
// 		СоответствиеИмен.Вставить("Сумма",   "Приход");
// 		СоответствиеИмен.Вставить("СуммаПР", "ПриходПР");
// 		СоответствиеИмен.Вставить("СуммаВР", "ПриходВР");
// 		СоответствиеИмен.Вставить("Сумма",   "Расход");
// 		СоответствиеИмен.Вставить("СуммаПР", "РасходПР");
// 		СоответствиеИмен.Вставить("СуммаВР", "РасходВР");
//
// Во всех случаях под соответствием коллекции описанию понимается наличие в коллекции свойств,
// предусмотренных описанием, и имеющих подходящий тип.
// При этом коллекции могут иметь и другие поля, в том числе, соответствовать и более 
// "широкому" описанию, включать не описанные наборы сумм.
// 
#КонецОбласти

#Область ОписаниеКоллекции

// Конструктор описания коллекции
// 
// Пример:
//  Описание = НовыйОписаниеКоллекцииСумм();
//  ДобавитьНаборСумм(Описание, "БухгалтерскийНалоговыйУчет", "Сумма,СуммаНУ");
//  ДобавитьПеременныйНаборСумм(Описание,    "ЭлементыЗатрат",             "Сумма");
//
Функция НовыйОписаниеКоллекцииСумм() Экспорт
	
	ОписаниеКоллекции = Новый Структура;
	ОписаниеКоллекции.Вставить("НаборыСумм",                 Новый Структура);
	ОписаниеКоллекции.Вставить("ЗначенияПоУмолчанию",        Новый Структура);
	ОписаниеКоллекции.Вставить("ИменаВсехСвойствСтрокой",    "");
	// Фиксированные наборы
	ОписаниеКоллекции.Вставить("ИменаСвойств",               Новый Массив);
	ОписаниеКоллекции.Вставить("ИменаСвойствСтрокой",        "");
	// Переменные наборы
	ОписаниеКоллекции.Вставить("ИменаПеременныхНаборовСумм", Новый Массив);
	
	Возврат ОписаниеКоллекции;
	
КонецФункции

Функция НовыйОписаниеНабораСумм(Переменный, ИменаСвойствСтрокой)
	
	ИменаСвойств = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИменаСвойствСтрокой, ",", Ложь, Истина);
	
	ОписаниеНабора = Новый Структура;
	ОписаниеНабора.Вставить("Переменный",          Переменный);
	ОписаниеНабора.Вставить("ИменаСвойств",        ИменаСвойств);
	ОписаниеНабора.Вставить("ИменаСвойствСтрокой", ИменаСвойствСтрокой);
	
	Если Переменный Тогда
		// В переменных наборах смысловой состав ИменаСвойств и ИменаСвойствСтрокой может отличаться:
		// - ИменаСвойствСтрокой включает ДополнительныеЗначения
		// - ИменаСвойств - нет
		ОписаниеНабора.Вставить("ДополнительныеЗначения", Новый Структура);
		ОписаниеНабора.Вставить("Шаблон",                 Новый ФиксированнаяСтруктура);
		ОписаниеНабора.Вставить("ЗначениеПоУмолчанию",    Новый ТаблицаЗначений);// Инициализированная коллекция
	КонецЕсли;
	
	Возврат ОписаниеНабора;
		
КонецФункции

// Добавляет в описание коллекции сумм описание набора с фиксированным составом.
//
// Параметры:
//  ОписаниеКоллекции - описание, сконструированное функцией НовыйОписаниеКоллекцииСумм()
//  ИмяНабора    - Строка
//  СоставНабора - Строка - имена свойств коллекции, разделенные запятыми
//
Процедура ДобавитьНаборСумм(ОписаниеКоллекции, ИмяНабора, СоставНабора) Экспорт
	
	// Заполним ОписаниеНабора
	ОписаниеНабора = НовыйОписаниеНабораСумм(Ложь, СоставНабора);
	ОписаниеКоллекции.НаборыСумм.Вставить(ИмяНабора, ОписаниеНабора);
	
	// Приведем свойства ОписаниеКоллекции в соответствие с ОписаниеНабора
	ДополнитьСоставНабораСумм(ОписаниеКоллекции, СоставНабора, Ложь);
	
	Для Каждого ИмяСвойства Из ОписаниеНабора.ИменаСвойств Цикл
		ОписаниеКоллекции.ИменаСвойств.Добавить(ИмяСвойства);
		ОписаниеКоллекции.ЗначенияПоУмолчанию.Вставить(ИмяСвойства, 0);
	КонецЦикла;
	
КонецПроцедуры

// Добавляет в описание коллекции сумм описание набора, который может содержать переменное число элементов.
//
// Параметры:
//  ОписаниеКоллекции - описание, сконструированное функцией НовыйОписаниеКоллекцииСумм()
//  ИмяНабора    - Строка
//  СоставНабора - Строка - имена свойств коллекции, разделенные запятыми
//  ДополнительныеЗначения 
//               - Структура - описание дополнительных (не суммовых) значений переменного набора.
//                  * Ключ     - Строка        - имя свойства (элемента набора)
//                  * Значение - ОписаниеТипов - тип свойства
//
Процедура ДобавитьПеременныйНаборСумм(ОписаниеКоллекции, ИмяНабора, СоставНабора, ДополнительныеЗначения = Неопределено) Экспорт
	
	// Заполним ОписаниеНабора
	ОписаниеНабора = НовыйОписаниеНабораСумм(Истина, СоставНабора);
	Если ДополнительныеЗначения <> Неопределено Тогда
		ОписаниеНабора.ДополнительныеЗначения = ДополнительныеЗначения;
	КонецЕсли;
	
	Шаблон = Новый Структура;
	Для Каждого ИмяСвойства Из ОписаниеНабора.ИменаСвойств Цикл
		Шаблон.Вставить(ИмяСвойства, 0);
	КонецЦикла;
	
	Для Каждого ОписаниеЗначения Из ОписаниеНабора.ДополнительныеЗначения Цикл
		Шаблон.Вставить(ОписаниеЗначения.Ключ, ОписаниеЗначения.Значение.ПривестиЗначение(Неопределено));
		Если ОписаниеНабора.ИменаСвойствСтрокой = "" Тогда
			ОписаниеНабора.ИменаСвойствСтрокой = ОписаниеЗначения.Ключ;
		Иначе
			ОписаниеНабора.ИменаСвойствСтрокой = ОписаниеНабора.ИменаСвойствСтрокой + "," + ОписаниеЗначения.Ключ;
		КонецЕсли;
	КонецЦикла;
	
	ОписаниеНабора.ЗначениеПоУмолчанию = НовыйПеременныйНаборСумм(
		ОписаниеНабора.ИменаСвойств,
		ОписаниеНабора.ДополнительныеЗначения);
	ОписаниеНабора.Шаблон = Новый ФиксированнаяСтруктура(Шаблон);
	
	ОписаниеКоллекции.НаборыСумм.Вставить(ИмяНабора, ОписаниеНабора);
	
	// Приведем свойства ОписаниеКоллекции в соответствие с ОписаниеНабора
	ДополнитьСоставНабораСумм(ОписаниеКоллекции, ИмяНабора, Истина);
		
	ОписаниеКоллекции.ИменаПеременныхНаборовСумм.Добавить(ИмяНабора);
	
	ОписаниеКоллекции.ЗначенияПоУмолчанию.Вставить(ИмяНабора, Новый ТаблицаЗначений); // неинициализированная коллекция
		
КонецПроцедуры

Процедура ДополнитьСоставНабораСумм(ОписаниеКоллекции, СоставНабора, Переменный)
	
	Если ПустаяСтрока(ОписаниеКоллекции.ИменаВсехСвойствСтрокой) Тогда
		ОписаниеКоллекции.ИменаВсехСвойствСтрокой = СоставНабора;
	Иначе
		ОписаниеКоллекции.ИменаВсехСвойствСтрокой = ОписаниеКоллекции.ИменаВсехСвойствСтрокой + "," + СоставНабора;
	КонецЕсли;
	
	Если Не Переменный Тогда
		Если ПустаяСтрока(ОписаниеКоллекции.ИменаСвойствСтрокой) Тогда
			ОписаниеКоллекции.ИменаСвойствСтрокой = СоставНабора;
		Иначе
			ОписаниеКоллекции.ИменаСвойствСтрокой = ОписаниеКоллекции.ИменаСвойствСтрокой + "," + СоставНабора;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

// Проверяет наличие набора в описании коллекции сумм.
//
// Параметры:
//  ОписаниеКоллекции - описание, сконструированное функцией НовыйОписаниеКоллекцииСумм()
//
//  ИмяНабора         - Строка
//
// Возвращаемое значение:
//  Булево
//
Функция ЕстьНаборСумм(ОписаниеКоллекции, ИмяНабора) Экспорт
	
	Возврат ОписаниеКоллекции.НаборыСумм.Свойство(ИмяНабора);
	
КонецФункции

// Определяет перечень свойств фиксированных наборов коллекции сумм.
//
// Параметры:
//  ОписаниеКоллекции - описание, сконструированное функцией НовыйОписаниеКоллекцииСумм() или НовыйОписаниеНабораСумм()
//
// Возвращаемое значение:
//  Строка - перечень имен свойств, разделенных запятыми
//
Функция ИменаСвойствСтрокой(ОписаниеКоллекции) Экспорт
	
	Возврат ОписаниеКоллекции.ИменаСвойствСтрокой;
	
КонецФункции

// Определяет перечень свойств фиксированных наборов коллекции сумм.
//
// Параметры:
//  ОписаниеКоллекции - описание, сконструированное функцией НовыйОписаниеКоллекцииСумм() или НовыйОписаниеНабораСумм()
//
// Возвращаемое значение:
//  Массив - строки, имена свойств
//
Функция ИменаСвойств(ОписаниеСумм) Экспорт
	
	Возврат ОписаниеСумм.ИменаСвойств;
	
КонецФункции

#КонецОбласти

#Область СозданиеКоллекции

// Конструктор коллекции сумм.
//
// Параметры:
//  ОписаниеКоллекции - описание, сконструированное функцией НовыйОписаниеКоллекцииСумм()
//  ДляЗаполнения - Булево - Истина, если коллекция следом будет неминуемо заполнена.
//                  Передача параметра пропускает заполнение значениями по умолчанию
//                  и тем самым позволяет оптимизировать время выполнения.
//
Функция НовыйКоллекцияСумм(ОписаниеКоллекции, ДляЗаполнения = Ложь) Экспорт
	
	Если ПустаяСтрока(ОписаниеКоллекции.ИменаВсехСвойствСтрокой) Тогда
		Возврат Новый Структура;
	КонецЕсли;
	
	// Создадим элементы для фиксированных наборов
	Коллекция = Новый Структура(ОписаниеКоллекции.ИменаВсехСвойствСтрокой);
	Если Не ДляЗаполнения Тогда
		Заполнить(Коллекция, ОписаниеКоллекции.ЗначенияПоУмолчанию, ОписаниеКоллекции);
	КонецЕсли;
		
	Возврат Коллекция;
	
КонецФункции

// Заполняет коллекцию сумм на основании другой коллекции сумм.
//
// Параметры:
//  Коллекция         - Заполняемая коллекция - должна соответствовать ОписаниеКоллекций
//
//  Основание         - Коллекция сумм - должна соответствовать ОписаниеКоллекций
//
//  ОписаниеКоллекций - описание, сконструированное функцией НовыйОписаниеКоллекцииСумм().
//
//  СоответствиеИмен  - Соответствие - (необязательный) правила соответствия имен свойств коллекции-основания и заполняемой коллекции.
//                      В ключе элемента соответствия - имя свойства заполняемой коллекции,
//                      в значении - имя свойства коллекции-основания.
//
Процедура Заполнить(Коллекция, Основание, ОписаниеКоллекций, СоответствиеИмен = Неопределено) Экспорт
	
	// Фиксированные наборы
	Если СоответствиеИмен = Неопределено Тогда
		ЗаполнитьЗначенияСвойств(Коллекция, Основание, ОписаниеКоллекций.ИменаСвойствСтрокой);
	Иначе // С учетом соответствия имен
		Для Каждого ИмяСвойства Из ОписаниеКоллекций.ИменаСвойств Цикл
			ИмяСвойстваОснования = СоответствиеИмен[ИмяСвойства];
			Если ИмяСвойстваОснования = Неопределено Тогда
				Коллекция[ИмяСвойства] = Основание[ИмяСвойства];
			Иначе
				Коллекция[ИмяСвойства] = Основание[ИмяСвойстваОснования];
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Заполним переменные наборы
	Для Каждого ИмяНабора Из ОписаниеКоллекций.ИменаПеременныхНаборовСумм Цикл
		ДанныеНабора = Основание[ИмяНабора];
		Если ЗначениеЗаполнено(ДанныеНабора) Тогда
			Коллекция[ИмяНабора] = Основание[ИмяНабора].Скопировать();
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Позволяет работать со строками таблицы значений как с коллекциями сумм.
// Перед первым изменением переменного набора сумм в каждой из строк,
// следует инициализировать этот набор - см. ИнициализироватьПеременныйНаборСумм()
//
// Параметры:
//  Результат         - ТаблицаЗначений - дополняемая таблица значений (коллекция коллекций сумм)
//
//  ОписаниеКоллекции - описание, сконструированное функцией НовыйОписаниеКоллекцииСумм().
//                      Таблица значений приводится к этому описанию.
//
Процедура ДополнитьТаблицуЗначенийКолонкамиСумм(Результат, ОписаниеКоллекции) Экспорт
	
	Для Каждого ИмяСвойства Из ОписаниеКоллекции.ИменаСвойств Цикл
		Результат.Колонки.Добавить(ИмяСвойства, БухгалтерскийУчетКлиентСервер.ТипСумма());
	КонецЦикла;
	
	Для Каждого ИмяНабора Из ОписаниеКоллекции.ИменаПеременныхНаборовСумм Цикл
		// При первом обращении на изменение следует инициализировать 
		// - см. ИнициализироватьПеременныйНаборСумм()
		Результат.Колонки.Добавить(ИмяНабора, Новый ОписаниеТипов("ТаблицаЗначений"));
	КонецЦикла;
	
КонецПроцедуры

Функция НовыйПеременныйНаборСумм(ИменаСвойств, ДополнительныеЗначения)
	
	КоллекцияСумм = Новый ТаблицаЗначений;
	КоллекцияСумм.Колонки.Добавить("Идентификатор", УчетЗатрат.ТипИдентификатораВершины());
	Для Каждого ИмяСвойства Из ИменаСвойств Цикл
		КоллекцияСумм.Колонки.Добавить(ИмяСвойства,  БухгалтерскийУчетКлиентСервер.ТипСумма());
	КонецЦикла;
	Для Каждого ОписаниеЗначения Из ДополнительныеЗначения Цикл
		КоллекцияСумм.Колонки.Добавить(ОписаниеЗначения.Ключ, ОписаниеЗначения.Значение);
	КонецЦикла;
	КоллекцияСумм.Индексы.Добавить("Идентификатор");
	Возврат КоллекцияСумм;
	
КонецФункции

// Позволяет изменять переменный набор сумм, входящий в коллекцию, 
// созданную без использования конструктора НовыйКоллекцияСумм()
//
// Параметры:
//  Коллекция - Заполняемая коллекция - должна включать переменный набор сумм с именем ИмяНабора
//
//  ИмяНабора - Строка - имя инициализируемого набора
//
// Возвращаемое значение:
//  ТаблицаЗначений - переменный набор сумм
//
Функция ИнициализироватьПеременныйНаборСумм(Коллекция, ИмяНабора, ОписаниеКоллекции) Экспорт
	
	Набор = Коллекция[ИмяНабора];
	Если ТипЗнч(Набор) <> Тип("ТаблицаЗначений") 
		Или Не ЗначениеЗаполнено(Набор.Колонки) Тогда
		ОписаниеНабора = ОписаниеКоллекции.НаборыСумм[ИмяНабора];
		Коллекция[ИмяНабора] = ОписаниеНабора.ЗначениеПоУмолчанию.Скопировать();
	КонецЕсли;
	
	Возврат Коллекция[ИмяНабора];
	
КонецФункции

#КонецОбласти

#Область ОперацииНадКоллекциями

// Прибавляет к каждой из сумм, входящей в коллекцию А, соответствующую сумму, входящую в коллекцию Б.
// 
// Параметры:
//  КоллекцияА        - первое слагаемое, модифицируемая коллекция, должна соответствовать ОписаниеКоллекций
//
//  КоллекцияБ        - второе слагаемое, не изменяется, должна соответствовать ОписаниеКоллекций
//
//  ОписаниеКоллекций - описание, сконструированное функцией НовыйОписаниеКоллекцииСумм()
// 
Процедура Сложить(КоллекцияА, КоллекцияБ, ОписаниеКоллекций) Экспорт
	
	Для Каждого ИмяСвойства Из ОписаниеКоллекций.ИменаСвойств Цикл
		
		ЗначениеБ = КоллекцияБ[ИмяСвойства];
		Если ЗначениеБ <> 0 Тогда
			КоллекцияА[ИмяСвойства] = КоллекцияА[ИмяСвойства] + ЗначениеБ;
		КонецЕсли;
					
	КонецЦикла;
	
	Для Каждого ИмяНабора Из ОписаниеКоллекций.ИменаПеременныхНаборовСумм Цикл
				
		НаборСуммБ = КоллекцияБ[ИмяНабора];
		
		Если ЗначениеЗаполнено(НаборСуммБ) Тогда
			
			НаборСуммА = ИнициализироватьПеременныйНаборСумм(КоллекцияА, ИмяНабора, ОписаниеКоллекций);
			
			ИменаСвойствСтрокой = ОписаниеКоллекций.НаборыСумм[ИмяНабора].ИменаСвойствСтрокой;
			
			Для Каждого СтрокаБ Из НаборСуммБ Цикл
				СтрокаА = НаборСуммА.Добавить();
				СтрокаА.Идентификатор = СтрокаБ.Идентификатор;
				ЗаполнитьЗначенияСвойств(СтрокаА, СтрокаБ, ИменаСвойствСтрокой);
			КонецЦикла;
			
			НаборСуммА.Свернуть("Идентификатор", ИменаСвойствСтрокой);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Вычитает из каждой из сумм, входящей в коллекцию А, соответствующую сумму, входящую в коллекцию Б.
// 
// Параметры:
//  КоллекцияА        - уменьшаемое, модифицируемая коллекция, должна соответствовать ОписаниеКоллекций
//
//  КоллекцияБ        - вычитаемое, не изменяется, должна соответствовать ОписаниеКоллекций
//
//  ОписаниеКоллекций - описание, сконструированное функцией НовыйОписаниеКоллекцииСумм()
// 
Процедура Вычесть(КоллекцияА, КоллекцияБ, ОписаниеКоллекций) Экспорт
	
	Для Каждого ИмяСвойства Из ОписаниеКоллекций.ИменаСвойств Цикл
		
		ЗначениеБ = КоллекцияБ[ИмяСвойства];
		Если ЗначениеБ <> 0 Тогда
			КоллекцияА[ИмяСвойства] = КоллекцияА[ИмяСвойства] - ЗначениеБ;
		КонецЕсли;
					
	КонецЦикла;
	
	Для Каждого ИмяНабора Из ОписаниеКоллекций.ИменаПеременныхНаборовСумм Цикл
				
		НаборСуммБ = КоллекцияБ[ИмяНабора];
		
		Если ЗначениеЗаполнено(НаборСуммБ) Тогда
			
			НаборСуммА = ИнициализироватьПеременныйНаборСумм(КоллекцияА, ИмяНабора, ОписаниеКоллекций);
			
			ОписаниеНабора = ОписаниеКоллекций.НаборыСумм[ИмяНабора];
			ИменаСвойств        = ОписаниеНабора.ИменаСвойств;
			ИменаСвойствСтрокой = ОписаниеНабора.ИменаСвойствСтрокой;
			
			Для Каждого СтрокаБ Из НаборСуммБ Цикл
				СтрокаА = НаборСуммА.Добавить();
				СтрокаА.Идентификатор = СтрокаБ.Идентификатор;
				Для Каждого ИмяСвойства Из ИменаСвойств Цикл
					СтрокаА[ИмяСвойства] = - СтрокаБ[ИмяСвойства];
				КонецЦикла;
				Для Каждого ОписаниеДополнительногоЗначения Из ОписаниеНабора.ДополнительныеЗначения Цикл
					СтрокаА[ОписаниеДополнительногоЗначения.Ключ] = - СтрокаБ[ОписаниеДополнительногоЗначения.Ключ];
				КонецЦикла;
			КонецЦикла;
			
			НаборСуммА.Свернуть("Идентификатор", ИменаСвойствСтрокой);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Проверяет коллекцию сумм на тривиальность.
// 
// Параметры:
//  Коллекция - проверяемая коллекция сумм, должна соответствовать ОписаниеКоллекции
//
//  ОписаниеКоллекции - описание, сконструированное функцией НовыйОписаниеКоллекцииСумм()
//
// Возвращаемое значение:
//  Булево - Истина, если все суммы в коллекции не заполнены (равны нулю)
// 
Функция Пустая(Коллекция, ОписаниеКоллекции) Экспорт
	
	Для Каждого ИмяСвойства Из ОписаниеКоллекции.ИменаСвойств Цикл
		
		Если ЗначениеЗаполнено(Коллекция[ИмяСвойства]) Тогда
			Возврат Ложь;
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого ИмяНабора Из ОписаниеКоллекции.ИменаПеременныхНаборовСумм Цикл
		
		Если Не ЗначениеЗаполнено(Коллекция[ИмяНабора]) Тогда
			Продолжить;
		КонецЕсли;
		
		ОписаниеНабораСумм = ОписаниеКоллекции.НаборыСумм[ИмяНабора];
		ИменаСвойств                   = ОписаниеНабораСумм.ИменаСвойств;
		ОписаниеДополнительныхЗначений = ОписаниеНабораСумм.ДополнительныеЗначения;
		
		Для Каждого ЭлементНабораСумм Из Коллекция[ИмяНабора] Цикл
			
			Для Каждого ИмяСвойства Из ИменаСвойств Цикл
				
				Если ЗначениеЗаполнено(ЭлементНабораСумм[ИмяСвойства]) Тогда
					Возврат Ложь;
				КонецЕсли;
				
			КонецЦикла;
			
			Для Каждого ОписаниеЗначения Из ОписаниеДополнительныхЗначений Цикл
				
				Если ЗначениеЗаполнено(ЭлементНабораСумм[ОписаниеЗначения.Ключ]) Тогда
					Возврат Ложь;
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;
		
	Возврат Истина;
	
КонецФункции

// Обеспечивает, что все суммы фиксированных наборов коллекции Суммы 
// будут меньше или равны соответствующим суммам в коллекции Ограничения.
//
// Параметры:
//  Суммы        - контролируемая (модифицируемая) коллекция, должна соответствовать ОписаниеКоллекций
//
//  Ограничения  - не изменяется, должна соответствовать ОписаниеКоллекций
//
//  ОписаниеКоллекций - описание, сконструированное функцией НовыйОписаниеКоллекцииСумм()
// 
Процедура Ограничить(Суммы, Ограничения, ОписаниеКоллекций) Экспорт
	
	// Не умеет работать с переменными наборами
	
	Для Каждого ИмяСвойства Из ОписаниеКоллекций.ИменаСвойств Цикл
		
		Сумма       = Суммы[ИмяСвойства];
		Ограничение = Макс(0, Ограничения[ИмяСвойства]);
		
		Если Ограничение > Сумма Тогда
			// В пределах
			Продолжить;
		КонецЕсли;
		
		Суммы[ИмяСвойства] = Ограничение;
		
	КонецЦикла;
	
КонецПроцедуры

// Рассчитывает долю для каждого элемента коллекции сумм.
// Результат помещает в новую коллекцию.
// Гарантированно доля рассчитывается для фиксированных наборов.
// Переменные наборы будут заполнены только в тривиальном случае, когда доля = 1.
//
// Параметры:
//  Коллекция         - коллекция сумм, доли которых надо рассчитать; должна соответствовать ОписаниеКоллекций
//
//  ОписаниеКоллекции - описание, сконструированное функцией НовыйОписаниеКоллекцииСумм()
//
//  Числитель         - Число
//
//  Знаменатель       - Число
//
// Возвращаемое значение:
//  Коллекция, сконструированная функцией НовыйКоллекцияСумм(), содержит доли от переданных сумм
// 
Функция Доля(Коллекция, ОписаниеКоллекции, Числитель, Знаменатель) Экспорт
	
	Если Числитель = Знаменатель Или Знаменатель = 0 Тогда
		
		Результат = НовыйКоллекцияСумм(ОписаниеКоллекции, Истина);
		Заполнить(Результат, Коллекция, ОписаниеКоллекции);
		
		Возврат Результат;
		
	КонецЕсли;
	
	Результат = НовыйКоллекцияСумм(ОписаниеКоллекции);
	Для Каждого ИмяСвойства Из ОписаниеКоллекции.ИменаСвойств Цикл
		Результат[ИмяСвойства] = ДоляСуммы(Коллекция[ИмяСвойства], Числитель, Знаменатель);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ДоляСуммы(Знач Сумма, Знач Числитель, Знач Знаменатель, ОписаниеТипаЗначения = Неопределено) Экспорт
	
	Если Числитель = Знаменатель Или Знаменатель = 0 Тогда
		Возврат Сумма;
	КонецЕсли;
	
	Цена = Сумма / Знаменатель;
	Доля = Цена * Числитель;
	
	Если ОписаниеТипаЗначения = Неопределено Тогда
		Возврат Окр(Доля, БухгалтерскийУчетКлиентСервер.РазрядностьДробнойЧастиСумм());
	Иначе
		Возврат ОписаниеТипаЗначения.ПривестиЗначение(Доля);
	КонецЕсли;
	
КонецФункции

Функция ЭлементПеременногоНабораСумм(Коллекция, ИмяНабора, Идентификатор, ОписаниеКоллекции) Экспорт
	
	НаборСумм = ИнициализироватьПеременныйНаборСумм(Коллекция, ИмяНабора, ОписаниеКоллекции);
	
	Элемент = НаборСумм.Найти(Идентификатор, "Идентификатор");
	
	Если Элемент = Неопределено Тогда
		Элемент = НаборСумм.Добавить();
		Элемент.Идентификатор = Идентификатор;
	КонецЕсли;
	
	Возврат Элемент;
	
КонецФункции

Функция ДобавитьВПеременныйНаборСумм(НаборСумм, Идентификатор, Суммы, ОписаниеНабораСумм) Экспорт
	
	// Допускается использовать только для первоначального заполнения коллекции уникальными значениями
	// Перед использованием следует инициализировать переменный набор
	НоваяСтрока = НаборСумм.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяСтрока, Суммы, ОписаниеНабораСумм.ИменаСвойствСтрокой);
	НоваяСтрока.Идентификатор = Идентификатор;
	
	Возврат НоваяСтрока;
	
КонецФункции

Функция ИтогПеременногоНабораСумм(Коллекция, ИмяНабора, ОписаниеСумм) Экспорт
	
	ОписаниеНабораСумм = ОписаниеСумм.НаборыСумм[ИмяНабора];
	
	Результат = Новый Структура(ОписаниеНабораСумм.Шаблон);
	
	НаборСумм = Коллекция[ИмяНабора];
	Если Не ЗначениеЗаполнено(НаборСумм) Тогда
		Возврат Результат;
	КонецЕсли;
	
	Для Каждого ИмяСвойства Из ОписаниеНабораСумм.ИменаСвойств Цикл
		Результат[ИмяСвойства] = НаборСумм.Итог(ИмяСвойства);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
