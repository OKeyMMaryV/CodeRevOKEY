#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Формирует дерево прав по конкретному виду объекта для пользователя, шаблона, 
// либо массива пользователей или шаблонов.
// 
// Параметры:
//  ВидОбъекта  - ПеречислениеСсылка.бит_ВидыОбъектовСистемы.
//  СубъектДоступа  - СправочникСсылка.Пользователи,СправочникСсылка.бит_ШаблоныПравДоступа,Массив.
// 
// Возвращаемое значение:
//   Результат   - РезультатЗапроса.
// 
Функция СформироватьДеревоПрав(ВидОбъекта, СубъектДоступа, УсловиеОтключено) Экспорт

	Запрос = Новый Запрос;
		ТекстЗапроса = "ВЫБРАТЬ
		               |	ВложенныйЗапрос.ОбъектДоступа КАК ОбъектДоступа,
		               |	ВложенныйЗапрос.ОбъектДоступа.Отключено КАК Отключено,					   
		               |	ВложенныйЗапрос.ОбластьДоступа КАК ОбластьДоступа,
		               |	МАКСИМУМ(ВложенныйЗапрос.Редактирование) КАК Редактирование,
		               |	МАКСИМУМ(ВложенныйЗапрос.Создание) КАК Создание,
		               |	МАКСИМУМ(ВложенныйЗапрос.Копирование) КАК Копирование,
		               |	МАКСИМУМ(ВложенныйЗапрос.ПометкаНаУдаление) КАК ПометкаНаУдаление,
		               |	МАКСИМУМ(ВложенныйЗапрос.ПереносВГруппу) КАК ПереносВГруппу,
		               |	МАКСИМУМ(ВложенныйЗапрос.Проведение) КАК Проведение,
		               |	МАКСИМУМ(ВложенныйЗапрос.ОтменаПроведения) КАК ОтменаПроведения,
		               |	МАКСИМУМ(ВложенныйЗапрос.Печать) КАК Печать,
		               |	ВложенныйЗапрос.ЭтоГруппа КАК ЭтоГруппа
		               |ИЗ
		               |	(ВЫБРАТЬ
		               |		бит_ОбъектыСистемы.Ссылка КАК ОбъектДоступа,
		               |		ЗНАЧЕНИЕ(Справочник.бит_ОбластиДоступа.ПустаяСсылка) КАК ОбластьДоступа,
		               |		бит_ПраваДоступа.Редактирование КАК Редактирование,
		               |		бит_ПраваДоступа.Создание КАК Создание,
		               |		бит_ПраваДоступа.Копирование КАК Копирование,
		               |		бит_ПраваДоступа.ПометкаНаУдаление КАК ПометкаНаУдаление,
		               |		бит_ПраваДоступа.ПереносВГруппу КАК ПереносВГруппу,
		               |		бит_ПраваДоступа.Проведение КАК Проведение,
		               |		бит_ПраваДоступа.ОтменаПроведения КАК ОтменаПроведения,
		               |		бит_ПраваДоступа.Печать КАК Печать,
		               |		бит_ОбъектыСистемы.ЭтоГруппа КАК ЭтоГруппа
		               |	ИЗ
		               |		Справочник.бит_ОбъектыСистемы КАК бит_ОбъектыСистемы
		               |			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.бит_ПраваДоступа КАК бит_ПраваДоступа
		               |			ПО бит_ОбъектыСистемы.Ссылка = бит_ПраваДоступа.ОбъектДоступа
		               |				И %УсловиеСубъект%
		               |				И (бит_ПраваДоступа.ОбластьДоступа = ЗНАЧЕНИЕ(Справочник.бит_ОбластиДоступа.ПустаяСсылка) )
		               |	ГДЕ
		               |		бит_ОбъектыСистемы.ВидОбъекта = &ВидОбъекта
		               |	
		               |	ОБЪЕДИНИТЬ ВСЕ
		               |	
		               |	ВЫБРАТЬ
		               |		бит_ОбластиДоступа.Владелец,
		               |		бит_ОбластиДоступа.Ссылка,
		               |		бит_ПраваДоступа.Редактирование,
		               |		бит_ПраваДоступа.Создание,
		               |		бит_ПраваДоступа.Копирование,
		               |		бит_ПраваДоступа.ПометкаНаУдаление,
		               |		бит_ПраваДоступа.ПереносВГруппу,
		               |		бит_ПраваДоступа.Проведение,
		               |		бит_ПраваДоступа.ОтменаПроведения,
		               |		бит_ПраваДоступа.Печать,
		               |		бит_ОбластиДоступа.Владелец.ЭтоГруппа
		               |	ИЗ
		               |		Справочник.бит_ОбластиДоступа КАК бит_ОбластиДоступа
		               |			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.бит_ПраваДоступа КАК бит_ПраваДоступа
		               |			ПО бит_ОбластиДоступа.Ссылка = бит_ПраваДоступа.ОбластьДоступа
		               |				И %УсловиеСубъект%
		               |	ГДЕ
		               |		бит_ОбластиДоступа.Владелец.ВидОбъекта = &ВидОбъекта
		               |		И (НЕ бит_ОбластиДоступа.ПометкаУдаления)) КАК ВложенныйЗапрос
		               |
					   |    ГДЕ
					   |	ВложенныйЗапрос.ОбъектДоступа.ЭтоГруппа ИЛИ (НЕ ВложенныйЗапрос.ОбъектДоступа.ИмяОбъекта В (&МассивИменИсключений))
					   |    %УсловиеОтключено%
		               |СГРУППИРОВАТЬ ПО
		               |	ВложенныйЗапрос.ОбъектДоступа,
		               |	ВложенныйЗапрос.ОбластьДоступа,
		               |	ВложенныйЗапрос.ЭтоГруппа
		               |
		               |УПОРЯДОЧИТЬ ПО
		               |	ОбъектДоступа ИЕРАРХИЯ,
		               |	ОбластьДоступа,
					   |    ВложенныйЗапрос.ОбъектДоступа.Наименование
					   |АВТОУПОРЯДОЧИВАНИЕ";
					   
		
	Если ТипЗнч(СубъектДоступа) = Тип("Массив") Тогда
	     ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"%УсловиеСубъект%"," (бит_ПраваДоступа.СубъектДоступа В (&СубъектДоступа))");
	Иначе	
	     ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"%УсловиеСубъект%"," (бит_ПраваДоступа.СубъектДоступа = &СубъектДоступа)");
	КонецЕсли; 
	
	Если УсловиеОтключено = "Отключенные" Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"%УсловиеОтключено%","И (ВложенныйЗапрос.ОбъектДоступа.Отключено ИЛИ ВложенныйЗапрос.ОбластьДоступа.Отключено)");
	ИначеЕсли УсловиеОтключено = "НеОтключенные" Тогда	
		ТекстУсловия = "И НЕ ВложенныйЗапрос.ОбъектДоступа.Отключено 
		                | И (ВложенныйЗапрос.ОбластьДоступа = Значение(Справочник.бит_ОбластиДоступа.ПустаяСсылка) 
						|     ИЛИ НЕ ВложенныйЗапрос.ОбластьДоступа.Отключено)";
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"%УсловиеОтключено%",ТекстУсловия);
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"%УсловиеОтключено%","");
	КонецЕсли; 
	
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("ВидОбъекта",ВидОбъекта);
	Запрос.УстановитьПараметр("СубъектДоступа",СубъектДоступа);
	Запрос.УстановитьПараметр("МассивИменИсключений",бит_ПраваДоступа.СформироватьМассивИменИсключений());

	Результат = Запрос.Выполнить();
	
	
	Возврат Результат;
	
КонецФункции // БитСформироватьДеревоПрав()

// Определяет перечисление события для конкретного вида объекта.
// 
// Параметры:
//  ВидОбъекта  - ПеречислениеСсылка.бит_ВидыОбъектовСистемы.
// 
// Возвращаемое значение:
//   ПеречислениеСсылка.бит_ВидыСобытий[ххх].
// 
Функция ОпределитьСобытия(ВидОбъекта) Экспорт 
	
	События = Неопределено;
	Если ВидОбъекта = Перечисления.бит_ВидыОбъектовСистемы.Справочник Тогда
		События = Перечисления.бит_ВидыСобытийСправочника;  
	ИначеЕсли ВидОбъекта = Перечисления.бит_ВидыОбъектовСистемы.Документ Тогда	
		События = Перечисления.бит_ВидыСобытийДокумента;
	ИначеЕсли ВидОбъекта = Перечисления.бит_ВидыОбъектовСистемы.Отчет Тогда
		События = Перечисления.бит_ВидыСобытийОтчет;
	ИначеЕсли ВидОбъекта = Перечисления.бит_ВидыОбъектовСистемы.Обработка Тогда
		События = Перечисления.бит_ВидыСобытийОбработка;
	ИначеЕсли ВидОбъекта = Перечисления.бит_ВидыОбъектовСистемы.РегистрСведений Тогда
		События = Перечисления.бит_ВидыСобытийРегистрСведений;
	КонецЕсли; 
	
	Возврат События;
КонецФункции // БитОпределитьСобытия()

// Процедура Формирует массив с именами возможных событий для конкретного вида объекта.
// 
// Параметры:
//  ВидОбъекта  - ПеречислениеСсылка.бит_ВидыОбъектовСистемы.
// 
// Возвращаемое значение:
// МассивСобытий - Массив - Элементы имена событий.
// 
Функция ПолучитьИменаСобытий(ВидОбъекта) Экспорт
	
	МассивСобытий = Новый Массив;
	События = ОпределитьСобытия(ВидОбъекта);
	Для каждого ЗначениеПеречисления Из События Цикл
		ИмяЗначения = бит_ОбщегоНазначения.ПолучитьИмяЗначенияПеречисления(События,ЗначениеПеречисления);
		Если ИмяЗначения = "Печать" Тогда
		
			Продолжить;
		
		КонецЕсли; 
		
		МассивСобытий.Добавить(ИмяЗначения);
	КонецЦикла;
	
	Возврат МассивСобытий;
	
КонецФункции // бит_СформироватьМассивИменКолонок()

#КонецОбласти
 
#КонецЕсли
