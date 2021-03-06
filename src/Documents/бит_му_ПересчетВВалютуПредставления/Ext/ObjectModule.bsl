#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем мКоличествоСубконтоМУ Экспорт; // Хранит количество субконто международного учета в документе.

#КонецОбласти 

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	// Заполнить реквизиты значениями по умолчанию.
	бит_ОбщегоНазначения.ЗаполнитьШапкуДокумента(ЭтотОбъект
												,бит_ОбщиеПеременныеСервер.ЗначениеПеременной("глТекущийПользователь")
												,Неопределено);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
		
	Если ОбменДанными.Загрузка Тогда
		// В случае выполнения обмена данными не производить проверку.
		Возврат;			
	КонецЕсли; 
		

		
КонецПроцедуры // ПередЗаписью()
	
Процедура ПриЗаписи(Отказ)
		
	Если ОбменДанными.Загрузка Тогда
		// В случае выполнения обмена данными не производить проверку.
		Возврат;			
	КонецЕсли; 
		
	
		
КонецПроцедуры // ПриЗаписи()

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	

	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = бит_ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);
	
	 // Проверка ручной корректировки
	Если бит_ОбщегоНазначения.РучнаяКорректировкаОбработкаПроведения(РучнаяКорректировка,Отказ,Заголовок,ЭтотОбъект,Ложь) Тогда
		Возврат
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли; 
	
	СтруктураШапкиДокумента = бит_ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);

	СтруктураТаблиц 		= ПодготовитьТаблицыДокумента(СтруктураШапкиДокумента);	
	
	// Выполним движения
	Если НЕ Отказ Тогда
		ДвиженияПоРегистрам(СтруктураШапкиДокумента,СтруктураТаблиц,Отказ,Заголовок);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	бит_ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ, РучнаяКорректировка);

КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

// Функция готовит таблицы документа для проведения.
// 
// Параметры:
//  СтруктураШапкиДокумента - Структура.
// 
// Возвращаемое значение:
//  СтруктураТаблиц - Структура.
// 
Функция ПодготовитьТаблицыДокумента(СтруктураШапкиДокумента)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТрансляционныеРазницы.Счет КАК Счет,
	               |	ТрансляционныеРазницы.Субконто1 КАК Субконто1,
	               |	ТрансляционныеРазницы.Субконто2 КАК Субконто2,
	               |	ТрансляционныеРазницы.Субконто3 КАК Субконто3,
	               |	ТрансляционныеРазницы.Субконто4 КАК Субконто4,
	               |	ТрансляционныеРазницы.Разница КАК Разница,
	               |	ТрансляционныеРазницы.ВидОстатка КАК ВидОстатка
	               |ИЗ
	               |	Документ.бит_му_ПересчетВВалютуПредставления.ТрансляционныеРазницы КАК ТрансляционныеРазницы
	               |ГДЕ
	               |	ТрансляционныеРазницы.Ссылка = &Ссылка";
				   
	РезультатЗапроса = Запрос.Выполнить();
	Таблица = РезультатЗапроса.Выгрузить();
	
	СтруктураТаблиц = Новый Структура;
	СтруктураТаблиц.Вставить("ТрансляционныеРазницы", Таблица);
	
	Возврат СтруктураТаблиц;
	
КонецФункции // ПодготовитьТаблицыДокумента()

// Процедура выполняет движения по регистрам.
// 
Процедура ДвиженияПоРегистрам(СтруктураШапкиДокумента,СтруктураТаблиц,Отказ,Заголовок)
	
	Для каждого СтрокаТаблицы Из СтруктураТаблиц.ТрансляционныеРазницы Цикл
		
		Если СтрокаТаблицы.Счет.Вид = ВидСчета.Активный Тогда
		
			СформироватьДвижениеПоРегиструМУ(ВидСчета.Активный, СтрокаТаблицы, СтруктураШапкиДокумента);
		
		ИначеЕсли СтрокаТаблицы.Счет.Вид = ВидСчета.Пассивный Тогда
		
			СформироватьДвижениеПоРегиструМУ(ВидСчета.Пассивный, СтрокаТаблицы, СтруктураШапкиДокумента);	
			
		ИначеЕсли СтрокаТаблицы.Счет.Вид = ВидСчета.АктивноПассивный Тогда
			Если СтрокаТаблицы.ВидОстатка = Перечисления.бит_ДтКт.Дт Тогда
				СформироватьДвижениеПоРегиструМУ(ВидСчета.Активный, СтрокаТаблицы, СтруктураШапкиДокумента);
			Иначе
				СформироватьДвижениеПоРегиструМУ(ВидСчета.Пассивный, СтрокаТаблицы, СтруктураШапкиДокумента);
			КонецЕсли; 
		КонецЕсли; 
	
	КонецЦикла; 
	
КонецПроцедуры // ДвиженияПоРегистрам()

// Процедура формирует движение по регистру международного учета. 
//
// Параметры:
//  ВидСчетаСтроки - ВидСчета.
//  СтрокаТаблицы - СтрокаТаблицыЗначений.
//  СтруктураШапкиДокумента - Структура.
//
Процедура СформироватьДвижениеПоРегиструМУ(ВидСчетаСтроки, СтрокаТаблицы, СтруктураШапкиДокумента)

	Если СтрокаТаблицы.Разница = 0 Тогда
	
		Возврат;
	
	КонецЕсли; 
	
	Запись = Движения.бит_Дополнительный_2.Добавить();
	
	СтруктураПараметров = Новый Структура("Организация, Период, Содержание"
										 , СтруктураШапкиДокумента.Организация
										 , СтруктураШапкиДокумента.Дата
										 , НСтр("ru = 'Трансляционная разница'"));
										 
	Если СтрокаТаблицы.Разница > 0  
		И ВидСчетаСтроки = ВидСчета.Активный Тогда
		
		СтруктураПараметров.Вставить("СчетДТ"	 , СтрокаТаблицы.Счет);
		Для  ном = 1 по мКоличествоСубконтоМУ Цикл
			бит_му_ОбщегоНазначения.УстановитьСубконто(СтрокаТаблицы.Счет,Запись.СубконтоДт,ном,СтрокаТаблицы["Субконто"+ном]);			
		КонецЦикла; 
		
		СтруктураПараметров.Вставить("СчетКт"	 , СтруктураШапкиДокумента.СчетДоходов);
		Для  ном = 1 по мКоличествоСубконтоМУ Цикл
			бит_му_ОбщегоНазначения.УстановитьСубконто(СтруктураШапкиДокумента.СчетДоходов,Запись.СубконтоКт,ном,СтруктураШапкиДокумента["СубконтоДоходов"+ном]);			
		КонецЦикла; 
		
	ИначеЕсли СтрокаТаблицы.Разница < 0  
		И ВидСчетаСтроки = ВидСчета.Активный Тогда
		
		СтруктураПараметров.Вставить("СчетДТ"	 , СтруктураШапкиДокумента.СчетРасходов);
		Для  ном = 1 по мКоличествоСубконтоМУ Цикл
			бит_му_ОбщегоНазначения.УстановитьСубконто(СтруктураШапкиДокумента.СчетРасходов,Запись.СубконтоДт,ном,СтруктураШапкиДокумента["СубконтоРасходов"+ном]);			
		КонецЦикла; 
		
		СтруктураПараметров.Вставить("СчетКт"	 , СтрокаТаблицы.Счет);
		Для  ном = 1 по мКоличествоСубконтоМУ Цикл
			бит_му_ОбщегоНазначения.УстановитьСубконто(СтрокаТаблицы.Счет,Запись.СубконтоКт,ном,СтрокаТаблицы["Субконто"+ном]);			
		КонецЦикла; 
		
	ИначеЕсли СтрокаТаблицы.Разница > 0  
		И ВидСчетаСтроки = ВидСчета.Пассивный Тогда
		
		СтруктураПараметров.Вставить("СчетДТ"	 , СтруктураШапкиДокумента.СчетРасходов);
		Для  ном = 1 по мКоличествоСубконтоМУ Цикл
			бит_му_ОбщегоНазначения.УстановитьСубконто(СтруктураШапкиДокумента.СчетРасходов,Запись.СубконтоДт,ном,СтруктураШапкиДокумента["СубконтоРасходов"+ном]);			
		КонецЦикла; 
		
		СтруктураПараметров.Вставить("СчетКт"	 , СтрокаТаблицы.Счет);
		Для  ном = 1 по мКоличествоСубконтоМУ Цикл
			бит_му_ОбщегоНазначения.УстановитьСубконто(СтрокаТаблицы.Счет,Запись.СубконтоКт,ном,СтрокаТаблицы["Субконто"+ном]);			
		КонецЦикла; 
		
	ИначеЕсли СтрокаТаблицы.Разница < 0  
		И ВидСчетаСтроки = ВидСчета.Пассивный Тогда
		
		СтруктураПараметров.Вставить("СчетДТ"	 , СтрокаТаблицы.Счет);
		Для  ном = 1 по мКоличествоСубконтоМУ Цикл
			бит_му_ОбщегоНазначения.УстановитьСубконто(СтрокаТаблицы.Счет,Запись.СубконтоДт,ном,СтрокаТаблицы["Субконто"+ном]);			
		КонецЦикла; 
		
		СтруктураПараметров.Вставить("СчетКт"	 , СтруктураШапкиДокумента.СчетДоходов);
		Для  ном = 1 по мКоличествоСубконтоМУ Цикл
			бит_му_ОбщегоНазначения.УстановитьСубконто(СтруктураШапкиДокумента.СчетДоходов,Запись.СубконтоКт,ном,СтруктураШапкиДокумента["СубконтоДоходов"+ном]);			
		КонецЦикла; 
		
	КонецЕсли; 									 
	
	Запись.Период = ЭтотОбъект.ОтчетнаяДата;
	
	// Записываем только сумму упр
	Запись.СуммаУпр = ?(СтрокаТаблицы.Разница<0, -СтрокаТаблицы.Разница, СтрокаТаблицы.Разница);
	
	бит_му_ОбщегоНазначения.ЗаполнитьЗаписьРегистраМУ(Запись, СтруктураПараметров);

КонецПроцедуры // СформироватьДвижениеПоРегиструМУ()

#КонецОбласти 

#Область Инициализация

мКоличествоСубконтоМУ = 4;

#КонецОбласти 

#КонецЕсли
